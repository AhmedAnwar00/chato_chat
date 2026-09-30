import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/messaging/device_notification_token.dart';
import 'package:my_chatoo_chat/core/messaging/notification_event.dart';
import 'package:my_chatoo_chat/core/messaging/notification_messaging_service.dart';

void main() {
  test('returns the FCM token when permission is authorized', () async {
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.authorized,
      readToken: () async => ' device-token ',
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.authorized);
    expect(result.token, 'device-token');
    expect(result.hasToken, isTrue);
  });

  test('returns the FCM token when permission is provisional', () async {
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.provisional,
      readToken: () async => 'provisional-token',
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.provisional);
    expect(result.token, 'provisional-token');
  });

  test('skips the FCM token when permission is denied', () async {
    var readTokenCalls = 0;
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.denied,
      readToken: () async {
        readTokenCalls++;
        return 'should-not-be-read';
      },
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.denied);
    expect(result.token, isNull);
    expect(result.hasToken, isFalse);
    expect(readTokenCalls, 0);
  });

  test('skips the FCM token when permission is permanently denied', () async {
    var readTokenCalls = 0;
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.deniedPermanently,
      readToken: () async {
        readTokenCalls++;
        return 'should-not-be-read';
      },
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.deniedPermanently);
    expect(result.token, isNull);
    expect(readTokenCalls, 0);
  });

  test('skips the FCM token when permission is not determined', () async {
    var readTokenCalls = 0;
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.notDetermined,
      readToken: () async {
        readTokenCalls++;
        return 'should-not-be-read';
      },
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.notDetermined);
    expect(result.token, isNull);
    expect(readTokenCalls, 0);
  });

  test('returns no token when the granted token is empty', () async {
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.authorized,
      readToken: () async => '   ',
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.authorized);
    expect(result.token, isNull);
  });

  test('returns no token when token retrieval fails after grant', () async {
    final service = NotificationMessagingService(
      requestAuthorization: () async => AuthorizationStatus.authorized,
      readToken: () async => throw StateError('token unavailable'),
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.authorized);
    expect(result.token, isNull);
  });

  test('returns unavailable when the permission request fails', () async {
    var readTokenCalls = 0;
    final service = NotificationMessagingService(
      requestAuthorization: () async => throw StateError('permission failed'),
      readToken: () async {
        readTokenCalls++;
        return 'should-not-be-read';
      },
    );

    final result = await service.requestDeviceToken();

    expect(result.authorization, NotificationAuthorization.unavailable);
    expect(result.token, isNull);
    expect(readTokenCalls, 0);
  });

  group('notification events', () {
    test('emits a foreground message', () async {
      final foreground = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(
        foregroundMessages: () => foreground.stream,
      );
      addTearDown(foreground.close);
      final events = _recordEvents(service);

      await service.start();
      foreground.add(
        const RemoteMessage(
          messageId: ' fg-1 ',
          notification: RemoteNotification(title: ' Hello ', body: '   '),
          data: <String, dynamic>{
            'chatId': ' room ',
            'count': 1,
            'blank': '  ',
          },
        ),
      );
      await pumpEventQueue();

      expect(events, hasLength(1));
      expect(events.single.appState, NotificationAppState.foreground);
      expect(events.single.interaction, NotificationInteraction.received);
      expect(events.single.messageId, 'fg-1');
      expect(events.single.title, 'Hello');
      expect(events.single.body, isNull);
      expect(events.single.data, {'chatId': 'room'});
    });

    test('emits a background message handled by the service', () async {
      final service = _eventService(useDefaultBackgroundMessages: true);
      final events = _recordEvents(service);

      await service.start();
      NotificationMessagingService.handleBackgroundMessage(
        const RemoteMessage(
          messageId: 'bg-1',
          notification: RemoteNotification(title: 'Background', body: 'Ping'),
        ),
      );
      await pumpEventQueue();

      expect(events, hasLength(1));
      expect(events.single.appState, NotificationAppState.background);
      expect(events.single.interaction, NotificationInteraction.received);
      expect(events.single.messageId, 'bg-1');
      expect(events.single.title, 'Background');
      expect(events.single.body, 'Ping');
    });

    test('emits a tap that opens the app from the background', () async {
      final opened = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(openedMessages: () => opened.stream);
      addTearDown(opened.close);
      final events = _recordEvents(service);

      await service.start();
      opened.add(
        const RemoteMessage(
          messageId: 'open-1',
          notification: RemoteNotification(title: 'Open', body: 'Chat'),
        ),
      );
      await pumpEventQueue();

      expect(events, hasLength(1));
      expect(events.single.appState, NotificationAppState.background);
      expect(events.single.interaction, NotificationInteraction.opened);
      expect(events.single.messageId, 'open-1');
      expect(events.single.title, 'Open');
    });

    test('emits a tap that launches a terminated app', () async {
      final service = _eventService(
        readInitialMessage: () async => const RemoteMessage(
          messageId: 'term-1',
          notification: RemoteNotification(title: 'Launch', body: 'Now'),
          data: <String, dynamic>{'threadId': 't1'},
        ),
      );

      await service.start();
      final events = _recordEvents(service);
      await pumpEventQueue();

      expect(events, hasLength(1));
      expect(events.single.appState, NotificationAppState.terminated);
      expect(events.single.interaction, NotificationInteraction.opened);
      expect(events.single.messageId, 'term-1');
      expect(events.single.title, 'Launch');
      expect(events.single.body, 'Now');
      expect(events.single.data, {'threadId': 't1'});
    });

    test('emits nothing when the terminated launch has no message', () async {
      final service = _eventService(readInitialMessage: () async => null);
      final events = _recordEvents(service);

      await service.start();
      await pumpEventQueue();

      expect(events, isEmpty);
    });

    test('keeps later foreground messages after a stream failure', () async {
      final foreground = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(
        foregroundMessages: () => foreground.stream,
      );
      addTearDown(foreground.close);
      final events = _recordEvents(service);

      await service.start();
      foreground.addError(StateError('foreground failed'));
      foreground.add(const RemoteMessage(messageId: 'after-error'));
      await pumpEventQueue();

      expect(events.map((event) => event.messageId), ['after-error']);
    });

    test('still emits taps when the terminated read fails', () async {
      final opened = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(
        openedMessages: () => opened.stream,
        readInitialMessage: () async => throw StateError('initial failed'),
      );
      addTearDown(opened.close);
      final events = _recordEvents(service);

      await service.start();
      opened.add(const RemoteMessage(messageId: 'opened-after-failure'));
      await pumpEventQueue();

      expect(events, hasLength(1));
      expect(events.single.messageId, 'opened-after-failure');
      expect(events.single.interaction, NotificationInteraction.opened);
    });

    test(
      'still emits foreground messages when handler registration fails',
      () async {
        final foreground = StreamController<RemoteMessage>.broadcast();
        final service = _eventService(
          foregroundMessages: () => foreground.stream,
          registerBackgroundHandler: (_) => throw StateError('register failed'),
        );
        addTearDown(foreground.close);
        final events = _recordEvents(service);

        await service.start();
        foreground.add(const RemoteMessage(messageId: 'fg-after-register'));
        await pumpEventQueue();

        expect(events.single.messageId, 'fg-after-register');
      },
    );

    test('registers the background handler once', () async {
      final handlers = <BackgroundMessageHandler>[];
      final service = _eventService(registerBackgroundHandler: handlers.add);

      await service.start();
      await service.start();

      expect(handlers, [firebaseMessagingBackgroundHandler]);
    });

    test('does not listen twice when start is repeated', () async {
      final foreground = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(
        foregroundMessages: () => foreground.stream,
      );
      addTearDown(foreground.close);
      final events = _recordEvents(service);

      await service.start();
      await service.start();
      foreground.add(const RemoteMessage(messageId: 'once'));
      await pumpEventQueue();

      expect(events.map((event) => event.messageId), ['once']);
    });

    test('ignores a foreground source that cannot be opened', () async {
      final opened = StreamController<RemoteMessage>.broadcast();
      final service = _eventService(
        foregroundMessages: () => throw StateError('foreground unavailable'),
        openedMessages: () => opened.stream,
      );
      addTearDown(opened.close);
      final events = _recordEvents(service);

      await service.start();
      opened.add(const RemoteMessage(messageId: 'still-open'));
      await pumpEventQueue();

      expect(events.single.messageId, 'still-open');
      expect(events.single.appState, NotificationAppState.background);
    });
  });
}

NotificationMessagingService _eventService({
  RemoteMessageStream? foregroundMessages,
  RemoteMessageStream? backgroundMessages,
  RemoteMessageStream? openedMessages,
  InitialRemoteMessageReader? readInitialMessage,
  BackgroundMessageRegistrar? registerBackgroundHandler,
  bool useDefaultBackgroundMessages = false,
}) {
  return NotificationMessagingService(
    requestAuthorization: () async => AuthorizationStatus.denied,
    readToken: () async => null,
    foregroundMessages: foregroundMessages ?? _idleMessages,
    backgroundMessages: useDefaultBackgroundMessages
        ? null
        : backgroundMessages ?? _idleMessages,
    openedMessages: openedMessages ?? _idleMessages,
    readInitialMessage: readInitialMessage ?? () async => null,
    registerBackgroundHandler: registerBackgroundHandler ?? (_) {},
  );
}

Stream<RemoteMessage> _idleMessages() {
  return StreamController<RemoteMessage>.broadcast().stream;
}

List<NotificationEvent> _recordEvents(NotificationMessagingService service) {
  final events = <NotificationEvent>[];
  final subscription = service.watchEvents().listen(events.add);
  addTearDown(service.dispose);
  addTearDown(subscription.cancel);
  return events;
}
