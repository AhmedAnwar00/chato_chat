import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/features/signup/controller/signup_controller.dart';

void main() {
  test('empty email does not create a user', () async {
    final controller = SignUpController(authService: _failingService());

    await controller.signUp(email: '  ', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Enter your email.');
  });

  test('empty password does not create a user', () async {
    final controller = SignUpController(authService: _failingService());

    await controller.signUp(email: 'a@b.com', password: '');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Enter your password.');
  });

  test('phone identifier does not create a user', () async {
    final controller = SignUpController(authService: _failingService());

    await controller.signUp(email: '+20 100 123 4567', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Sign up with an email and password.');
  });

  test('email success clears the error', () async {
    String? capturedEmail;
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              capturedEmail = email;
            },
      ),
    );

    await controller.signUp(email: '  a@b.com  ', password: 'secret');

    expect(capturedEmail, 'a@b.com');
    expect(controller.status, SignUpStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('email failure sets the service message', () async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'weak-password');
            },
      ),
    );

    await controller.signUp(email: 'a@b.com', password: 'secret');

    expect(controller.status, SignUpStatus.error);
    expect(controller.errorMessage, 'Use a stronger password.');
  });

  test('ignores a second call while loading', () async {
    final completer = Completer<void>();
    var calls = 0;
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) {
              calls++;
              return completer.future;
            },
      ),
    );

    final first = controller.signUp(email: 'a@b.com', password: 'secret');
    final second = controller.signUp(email: 'a@b.com', password: 'secret');
    expect(controller.status, SignUpStatus.loading);
    expect(calls, 1);

    completer.complete();
    await first;
    await second;

    expect(controller.status, SignUpStatus.success);
    expect(calls, 1);
  });
}

AuthService _failingService() {
  return AuthService(
    createUserWithEmailAndPassword:
        ({required String email, required String password}) async {
          fail('should not create a user');
        },
  );
}
