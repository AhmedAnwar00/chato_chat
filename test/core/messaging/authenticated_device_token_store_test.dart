import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/messaging/authenticated_device_token_store.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';
import 'package:my_chatoo_chat/core/messaging/notification_messaging_service.dart';

void main() {
  test('saves the FCM token on the authenticated user', () async {
    String? documentId;
    String? savedToken;
    final store = _store(
      currentUserId: () => ' user-1 ',
      readToken: () async => ' device-token ',
      writeToken: ({required String uid, required String token}) async {
        documentId = uid;
        savedToken = token;
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.saved);
    expect(documentId, 'user-1');
    expect(savedToken, 'device-token');
  });

  test('does not write when nobody is signed in', () async {
    for (final userId in [null, '   ']) {
      var writes = 0;
      final store = _store(
        currentUserId: () => userId,
        readToken: () async => 'device-token',
        writeToken: ({required String uid, required String token}) async {
          writes++;
        },
      );

      final result = await store.saveForCurrentUser();

      expect(result.status, DeviceTokenSaveStatus.unauthenticated);
      expect(writes, 0);
    }
  });

  test('does not write when the FCM token is missing', () async {
    var writes = 0;
    final store = _store(
      currentUserId: () => 'user-1',
      authorization: AuthorizationStatus.denied,
      readToken: () async => 'should-not-be-read',
      writeToken: ({required String uid, required String token}) async {
        writes++;
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.missingToken);
    expect(writes, 0);
  });

  test('does not write when the granted token is empty', () async {
    var writes = 0;
    final store = _store(
      currentUserId: () => 'user-1',
      readToken: () async => '   ',
      writeToken: ({required String uid, required String token}) async {
        writes++;
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.missingToken);
    expect(writes, 0);
  });

  test('returns failed when the signed-in user cannot be read', () async {
    var writes = 0;
    final store = _store(
      currentUserId: () => throw StateError('auth unavailable'),
      readToken: () async => 'device-token',
      writeToken: ({required String uid, required String token}) async {
        writes++;
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.failed);
    expect(writes, 0);
  });

  test('returns failed when Firebase rejects the user write', () async {
    final store = _store(
      currentUserId: () => 'user-1',
      readToken: () async => 'device-token',
      writeToken: ({required String uid, required String token}) async {
        throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.failed);
  });

  test('returns failed when the user write fails unexpectedly', () async {
    final store = _store(
      currentUserId: () => 'user-1',
      readToken: () async => 'device-token',
      writeToken: ({required String uid, required String token}) async {
        throw StateError('raw database failure');
      },
    );

    final result = await store.saveForCurrentUser();

    expect(result.status, DeviceTokenSaveStatus.failed);
  });
}

AuthenticatedDeviceTokenStore _store({
  required String? Function() currentUserId,
  required Future<String?> Function() readToken,
  required DeviceNotificationTokenWriter writeToken,
  AuthorizationStatus authorization = AuthorizationStatus.authorized,
}) {
  return AuthenticatedDeviceTokenStore(
    messaging: NotificationMessagingService(
      requestAuthorization: () async => authorization,
      readToken: readToken,
    ),
    currentUserId: currentUserId,
    writeToken: writeToken,
  );
}
