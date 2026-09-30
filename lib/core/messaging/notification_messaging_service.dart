import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_chatoo_chat/core/messaging/device_notification_token.dart';
import 'package:my_chatoo_chat/core/messaging/notification_event.dart';
import 'package:my_chatoo_chat/firebase_options.dart';

typedef NotificationAuthorizationRequest =
    Future<AuthorizationStatus> Function();

typedef DeviceFcmTokenReader = Future<String?> Function();

typedef RemoteMessageStream = Stream<RemoteMessage> Function();

typedef InitialRemoteMessageReader = Future<RemoteMessage?> Function();

typedef BackgroundMessageRegistrar =
    void Function(BackgroundMessageHandler handler);

class NotificationMessagingService {
  NotificationMessagingService({
    NotificationAuthorizationRequest? requestAuthorization,
    DeviceFcmTokenReader? readToken,
    RemoteMessageStream? foregroundMessages,
    RemoteMessageStream? backgroundMessages,
    RemoteMessageStream? openedMessages,
    InitialRemoteMessageReader? readInitialMessage,
    BackgroundMessageRegistrar? registerBackgroundHandler,
  }) : _requestAuthorization =
           requestAuthorization ?? _firebaseRequestAuthorization,
       _readToken = readToken ?? _firebaseReadToken,
       _foregroundMessages = foregroundMessages ?? _firebaseForegroundMessages,
       _backgroundMessages = backgroundMessages ?? _firebaseBackgroundMessages,
       _openedMessages = openedMessages ?? _firebaseOpenedMessages,
       _readInitialMessage = readInitialMessage ?? _firebaseInitialMessage,
       _registerBackgroundHandler =
           registerBackgroundHandler ?? _firebaseRegisterBackgroundHandler;

  static final NotificationMessagingService instance =
      NotificationMessagingService();

  static final StreamController<RemoteMessage> _receivedBackgroundMessages =
      StreamController<RemoteMessage>.broadcast();

  final NotificationAuthorizationRequest _requestAuthorization;
  final DeviceFcmTokenReader _readToken;
  final RemoteMessageStream _foregroundMessages;
  final RemoteMessageStream _backgroundMessages;
  final RemoteMessageStream _openedMessages;
  final InitialRemoteMessageReader _readInitialMessage;
  final BackgroundMessageRegistrar _registerBackgroundHandler;
  final List<NotificationEvent> _bufferedEvents = <NotificationEvent>[];
  final List<_NotificationEventListener> _listeners =
      <_NotificationEventListener>[];
  final List<StreamSubscription<RemoteMessage>> _subscriptions =
      <StreamSubscription<RemoteMessage>>[];

  Future<void>? _startFuture;
  var _disposed = false;

  static void handleBackgroundMessage(RemoteMessage message) {
    if (_receivedBackgroundMessages.isClosed) {
      return;
    }
    _receivedBackgroundMessages.add(message);
  }

  Future<DeviceNotificationToken> requestDeviceToken() async {
    final AuthorizationStatus status;
    try {
      status = await _requestAuthorization();
    } on Object {
      return const DeviceNotificationToken(
        authorization: NotificationAuthorization.unavailable,
      );
    }

    final authorization = _authorization(status);
    if (!_allowsToken(authorization)) {
      return DeviceNotificationToken(authorization: authorization);
    }

    try {
      final token = (await _readToken())?.trim();
      if (token == null || token.isEmpty) {
        return DeviceNotificationToken(authorization: authorization);
      }
      return DeviceNotificationToken(
        authorization: authorization,
        token: token,
      );
    } on Object {
      return DeviceNotificationToken(authorization: authorization);
    }
  }

  Future<void> start() {
    return _startFuture ??= _start();
  }

  Stream<NotificationEvent> watchEvents() {
    late final StreamController<NotificationEvent> controller;
    final listener = _NotificationEventListener();
    controller = StreamController<NotificationEvent>(
      onListen: () {
        if (_disposed) {
          controller.close();
          return;
        }
        listener.controller = controller;
        listener.isActive = true;
        _listeners.add(listener);
        _deliver(listener);
      },
      onCancel: () {
        listener.isActive = false;
        _listeners.remove(listener);
      },
    );
    return controller.stream;
  }

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    for (final subscription in List<StreamSubscription<RemoteMessage>>.of(
      _subscriptions,
    )) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    for (final listener in List<_NotificationEventListener>.of(_listeners)) {
      listener.isActive = false;
      final controller = listener.controller;
      if (controller != null && !controller.isClosed) {
        await controller.close();
      }
    }
    _listeners.clear();
  }

  Future<void> _start() async {
    _listen(
      _foregroundMessages,
      appState: NotificationAppState.foreground,
      interaction: NotificationInteraction.received,
    );
    _listen(
      _backgroundMessages,
      appState: NotificationAppState.background,
      interaction: NotificationInteraction.received,
    );
    _listen(
      _openedMessages,
      appState: NotificationAppState.background,
      interaction: NotificationInteraction.opened,
    );
    _registerBackgroundHandlerSafely();
    await _readOpenedTerminatedMessage();
  }

  void _registerBackgroundHandlerSafely() {
    try {
      _registerBackgroundHandler(firebaseMessagingBackgroundHandler);
    } on Object {
      return;
    }
  }

  void _listen(
    RemoteMessageStream source, {
    required NotificationAppState appState,
    required NotificationInteraction interaction,
  }) {
    if (_disposed) {
      return;
    }
    try {
      final subscription = source().listen(
        (message) =>
            _publish(message, appState: appState, interaction: interaction),
        onError: _ignoreMessagingFailure,
        cancelOnError: false,
      );
      _subscriptions.add(subscription);
    } on Object {
      return;
    }
  }

  Future<void> _readOpenedTerminatedMessage() async {
    try {
      final message = await _readInitialMessage();
      if (message == null || _disposed) {
        return;
      }
      _publish(
        message,
        appState: NotificationAppState.terminated,
        interaction: NotificationInteraction.opened,
      );
    } on Object {
      return;
    }
  }

  void _publish(
    RemoteMessage message, {
    required NotificationAppState appState,
    required NotificationInteraction interaction,
  }) {
    if (_disposed) {
      return;
    }
    try {
      _add(
        NotificationEvent(
          appState: appState,
          interaction: interaction,
          messageId: _text(message.messageId),
          title: _text(message.notification?.title),
          body: _text(message.notification?.body),
          data: _stringData(message.data),
        ),
      );
    } on Object {
      return;
    }
  }

  void _add(NotificationEvent event) {
    if (_disposed) {
      return;
    }
    _bufferedEvents.add(event);
    for (final listener in List<_NotificationEventListener>.of(_listeners)) {
      _deliver(listener);
    }
  }

  void _deliver(_NotificationEventListener listener) {
    final controller = listener.controller;
    if (controller == null) {
      return;
    }
    while (listener.isActive &&
        !controller.isClosed &&
        listener.index < _bufferedEvents.length) {
      final event = _bufferedEvents[listener.index];
      listener.index += 1;
      controller.add(event);
    }
  }

  static Future<AuthorizationStatus> _firebaseRequestAuthorization() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    return settings.authorizationStatus;
  }

  static Future<String?> _firebaseReadToken() {
    return FirebaseMessaging.instance.getToken();
  }

  static Stream<RemoteMessage> _firebaseForegroundMessages() {
    return FirebaseMessaging.onMessage;
  }

  static Stream<RemoteMessage> _firebaseBackgroundMessages() {
    return _receivedBackgroundMessages.stream;
  }

  static Stream<RemoteMessage> _firebaseOpenedMessages() {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  static Future<RemoteMessage?> _firebaseInitialMessage() {
    return FirebaseMessaging.instance.getInitialMessage();
  }

  static void _firebaseRegisterBackgroundHandler(
    BackgroundMessageHandler handler,
  ) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  static NotificationAuthorization _authorization(AuthorizationStatus status) {
    return switch (status) {
      AuthorizationStatus.authorized => NotificationAuthorization.authorized,
      AuthorizationStatus.denied => NotificationAuthorization.denied,
      AuthorizationStatus.notDetermined =>
        NotificationAuthorization.notDetermined,
      AuthorizationStatus.provisional => NotificationAuthorization.provisional,
      AuthorizationStatus.deniedPermanently =>
        NotificationAuthorization.deniedPermanently,
    };
  }

  static bool _allowsToken(NotificationAuthorization authorization) {
    return authorization == NotificationAuthorization.authorized ||
        authorization == NotificationAuthorization.provisional;
  }

  static String? _text(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static Map<String, String> _stringData(Map<String, dynamic> data) {
    final sanitized = <String, String>{};
    for (final entry in data.entries) {
      final value = entry.value;
      if (entry.key.isEmpty || value is! String) {
        continue;
      }
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      sanitized[entry.key] = trimmed;
    }
    return Map<String, String>.unmodifiable(sanitized);
  }

  static void _ignoreMessagingFailure(Object _, StackTrace _) {}
}

class _NotificationEventListener {
  StreamController<NotificationEvent>? controller;
  int index = 0;
  var isActive = false;
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await _ensureFirebaseForBackgroundMessage();
  try {
    NotificationMessagingService.handleBackgroundMessage(message);
  } on Object {
    return;
  }
}

Future<void> _ensureFirebaseForBackgroundMessage() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on Object {
    return;
  }
}
