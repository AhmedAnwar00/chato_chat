import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:my_chatoo_chat/core/messaging/device_notification_token.dart';

typedef NotificationAuthorizationRequest =
    Future<AuthorizationStatus> Function();

typedef DeviceFcmTokenReader = Future<String?> Function();

class NotificationMessagingService {
  NotificationMessagingService({
    NotificationAuthorizationRequest? requestAuthorization,
    DeviceFcmTokenReader? readToken,
  }) : _requestAuthorization =
           requestAuthorization ?? _firebaseRequestAuthorization,
       _readToken = readToken ?? _firebaseReadToken;

  final NotificationAuthorizationRequest _requestAuthorization;
  final DeviceFcmTokenReader _readToken;

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

  static Future<AuthorizationStatus> _firebaseRequestAuthorization() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    return settings.authorizationStatus;
  }

  static Future<String?> _firebaseReadToken() {
    return FirebaseMessaging.instance.getToken();
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
}
