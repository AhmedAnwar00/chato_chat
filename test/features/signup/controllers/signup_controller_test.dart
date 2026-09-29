import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/auth/created_auth_user.dart';
import 'package:my_chatoo_chat/core/firestore/user_firestore_service.dart';
import 'package:my_chatoo_chat/features/signup/controller/signup_controller.dart';

void main() {
  test('empty name does not create a user', () async {
    final controller = SignUpController(
      authService: _failingAuth(),
      userFirestoreService: _failingStore(),
    );

    await controller.signUp(name: '  ', email: 'a@b.com', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Enter your name.');
  });

  test('empty email does not create a user', () async {
    final controller = SignUpController(
      authService: _failingAuth(),
      userFirestoreService: _failingStore(),
    );

    await controller.signUp(name: 'Ada', email: '  ', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Enter your email.');
  });

  test('empty password does not create a user', () async {
    final controller = SignUpController(
      authService: _failingAuth(),
      userFirestoreService: _failingStore(),
    );

    await controller.signUp(name: 'Ada', email: 'a@b.com', password: '');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Enter your password.');
  });

  test('phone identifier does not create a user', () async {
    final controller = SignUpController(
      authService: _failingAuth(),
      userFirestoreService: _failingStore(),
    );

    await controller.signUp(
      name: 'Ada',
      email: '+20 100 123 4567',
      password: 'secret',
    );

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Sign up with an email and password.');
  });

  test('success writes the profile after sign-up', () async {
    String? capturedEmail;
    String? documentId;
    Map<String, dynamic>? document;
    final before = DateTime.now();
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              capturedEmail = email;
              return CreatedAuthUser(uid: 'user-1', email: email);
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({required String uid, required Map<String, dynamic> data}) async {
              documentId = uid;
              document = data;
            },
      ),
    );

    await controller.signUp(
      name: '  Ada Lovelace  ',
      email: '  a@b.com  ',
      password: 'secret',
    );

    expect(capturedEmail, 'a@b.com');
    expect(documentId, 'user-1');
    expect(document?['uid'], 'user-1');
    expect(document?['email'], 'a@b.com');
    expect(document?['name'], 'Ada Lovelace');
    expect(document!.containsKey('password'), isFalse);
    final createdAt = document!['createdAt'] as DateTime;
    expect(createdAt.isBefore(before), isFalse);
    expect(controller.status, SignUpStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('auth failure does not write a profile', () async {
    var writes = 0;
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'weak-password');
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({
              required String uid,
              required Map<String, dynamic> data,
            }) async {
              writes++;
            },
      ),
    );

    await controller.signUp(name: 'Ada', email: 'a@b.com', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Use a stronger password.');
    expect(writes, 0);
  });

  test('profile failure sets a friendly message', () async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              return const CreatedAuthUser(uid: 'user-1', email: 'a@b.com');
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({
              required String uid,
              required Map<String, dynamic> data,
            }) async {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'unavailable',
              );
            },
      ),
    );

    await controller.signUp(name: 'Ada', email: 'a@b.com', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Check your connection and try again.');
  });

  test('ignores a second call while loading', () async {
    final completer = Completer<CreatedAuthUser>();
    var calls = 0;
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) {
              calls++;
              return completer.future;
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({
              required String uid,
              required Map<String, dynamic> data,
            }) async {},
      ),
    );

    final first = controller.signUp(
      name: 'Ada',
      email: 'a@b.com',
      password: 'secret',
    );
    final second = controller.signUp(
      name: 'Ada',
      email: 'a@b.com',
      password: 'secret',
    );
    expect(controller.status, SignUpStatus.loading);
    expect(calls, 1);

    completer.complete(const CreatedAuthUser(uid: 'user-1', email: 'a@b.com'));
    await first;
    await second;

    expect(controller.status, SignUpStatus.success);
    expect(calls, 1);
  });
}

AuthService _failingAuth() {
  return AuthService(
    createUserWithEmailAndPassword:
        ({required String email, required String password}) async {
          fail('should not create a user');
        },
  );
}

UserFirestoreService _failingStore() {
  return UserFirestoreService(
    writeUser:
        ({required String uid, required Map<String, dynamic> data}) async {
          fail('should not write a profile');
        },
  );
}
