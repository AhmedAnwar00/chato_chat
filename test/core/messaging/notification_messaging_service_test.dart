import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/messaging/device_notification_token.dart';
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
}
