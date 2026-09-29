import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chatoo_chat/core/firestore/firestore_failure.dart';
import 'package:my_chatoo_chat/features/signup/model/user_profile.dart';

typedef UserDocumentWriter = Future<void> Function({
  required String uid,
  required Map<String, dynamic> data,
});

class UserFirestoreService {
  UserFirestoreService({UserDocumentWriter? writeUser})
    : _writeUser = writeUser ?? _firestoreWriteUser;

  final UserDocumentWriter _writeUser;

  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _writeUser(uid: profile.uid, data: profile.toMap());
    } on FirebaseException catch (error) {
      throw FirestoreFailure(_message(error.code));
    } on FirestoreFailure {
      rethrow;
    } on Object {
      throw FirestoreFailure('Could not save your profile. Try again.');
    }
  }

  static Future<void> _firestoreWriteUser({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(data);
  }

  static String _message(String code) {
    return switch (code) {
      'permission-denied' => 'You do not have permission to save your profile.',
      'unavailable' || 'deadline-exceeded' =>
        'Check your connection and try again.',
      _ => 'Could not save your profile. Try again.',
    };
  }
}
