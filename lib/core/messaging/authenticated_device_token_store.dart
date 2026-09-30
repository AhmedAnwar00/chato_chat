import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';
import 'package:my_chatoo_chat/core/messaging/notification_messaging_service.dart';

typedef CurrentUserIdReader = String? Function();

typedef DeviceNotificationTokenWriter =
    Future<void> Function({required String uid, required String token});

class AuthenticatedDeviceTokenStore {
  AuthenticatedDeviceTokenStore({
    NotificationMessagingService? messaging,
    CurrentUserIdReader? currentUserId,
    DeviceNotificationTokenWriter? writeToken,
  }) : _messaging = messaging ?? NotificationMessagingService(),
       _currentUserId = currentUserId ?? _firebaseUserId,
       _writeToken = writeToken ?? _firestoreWriteToken;

  final NotificationMessagingService _messaging;
  final CurrentUserIdReader _currentUserId;
  final DeviceNotificationTokenWriter _writeToken;

  Future<DeviceTokenSaveResult> saveForCurrentUser() async {
    final deviceToken = await _messaging.requestDeviceToken();
    final String? uid;
    try {
      uid = _currentUserId()?.trim();
    } on Object {
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.failed);
    }
    if (uid == null || uid.isEmpty) {
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.unauthenticated);
    }

    final token = deviceToken.token?.trim();
    if (token == null || token.isEmpty) {
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.missingToken);
    }

    try {
      await _writeToken(uid: uid, token: token);
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.saved);
    } on FirebaseException {
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.failed);
    } on Object {
      return const DeviceTokenSaveResult(DeviceTokenSaveStatus.failed);
    }
  }

  static String? _firebaseUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> _firestoreWriteToken({
    required String uid,
    required String token,
  }) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));
  }
}
