import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/firestore/firestore_failure.dart';
import 'package:my_chatoo_chat/core/firestore/user_firestore_service.dart';
import 'package:my_chatoo_chat/features/signup/model/user_profile.dart';

void main() {
  final profile = UserProfile(
    uid: 'user-1',
    email: 'a@b.com',
    name: 'Ada',
    createdAt: _createdAt,
  );

  test('writes users/{uid} without a password', () async {
    String? documentId;
    Map<String, dynamic>? document;
    final service = UserFirestoreService(
      writeUser:
          ({required String uid, required Map<String, dynamic> data}) async {
            documentId = uid;
            document = data;
          },
    );

    await service.createUserProfile(profile);

    expect(documentId, 'user-1');
    expect(document, {
      'uid': 'user-1',
      'email': 'a@b.com',
      'name': 'Ada',
      'createdAt': _createdAt,
    });
    expect(document!.containsKey('password'), isFalse);
  });

  test('maps Firestore errors to friendly messages', () async {
    const cases = {
      'permission-denied': 'You do not have permission to save your profile.',
      'unavailable': 'Check your connection and try again.',
      'deadline-exceeded': 'Check your connection and try again.',
      'unknown': 'Could not save your profile. Try again.',
    };

    for (final entry in cases.entries) {
      final service = UserFirestoreService(
        writeUser:
            ({required String uid, required Map<String, dynamic> data}) async {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: entry.key,
              );
            },
      );

      await expectLater(
        service.createUserProfile(profile),
        throwsA(
          isA<FirestoreFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('maps unexpected errors to a friendly message', () async {
    final service = UserFirestoreService(
      writeUser:
          ({required String uid, required Map<String, dynamic> data}) async {
            throw StateError('raw firestore failure');
          },
    );

    await expectLater(
      service.createUserProfile(profile),
      throwsA(
        isA<FirestoreFailure>().having(
          (failure) => failure.message,
          'message',
          'Could not save your profile. Try again.',
        ),
      ),
    );
  });
}

final _createdAt = DateTime.utc(2026, 9, 29);
