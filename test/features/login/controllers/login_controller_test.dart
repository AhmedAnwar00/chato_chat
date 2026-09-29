import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/features/login/controller/login_controller.dart';

void main() {
  test('empty identifier does not sign in', () async {
    final controller = LoginController(authService: _failingService());

    await controller.signIn(identifier: '  ', password: 'secret');

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Enter your email or phone number.');
  });

  test('empty password does not sign in', () async {
    final controller = LoginController(authService: _failingService());

    await controller.signIn(identifier: 'a@b.com', password: '');

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Enter your password.');
  });

  test('phone identifier does not sign in', () async {
    final controller = LoginController(authService: _failingService());

    await controller.signIn(identifier: '+20 100 123 4567', password: 'secret');

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Phone sign-in is not available yet.');
  });

  test('email success clears the error', () async {
    String? capturedEmail;
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {
              capturedEmail = email;
            },
      ),
    );

    await controller.signIn(identifier: '  a@b.com  ', password: 'secret');

    expect(capturedEmail, 'a@b.com');
    expect(controller.status, LoginStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('email failure sets the service message', () async {
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'wrong-password');
            },
      ),
    );

    await controller.signIn(identifier: 'a@b.com', password: 'secret');

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Email or password is incorrect.');
  });

  test('ignores a second call while loading', () async {
    final completer = Completer<void>();
    var calls = 0;
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) {
              calls++;
              return completer.future;
            },
      ),
    );

    final first = controller.signIn(identifier: 'a@b.com', password: 'secret');
    final second = controller.signIn(identifier: 'a@b.com', password: 'secret');
    expect(controller.status, LoginStatus.loading);
    expect(calls, 1);

    completer.complete();
    await first;
    await second;

    expect(controller.status, LoginStatus.success);
    expect(calls, 1);
  });
}

AuthService _failingService() {
  return AuthService(
    signInWithEmailAndPassword:
        ({required String email, required String password}) async {
          fail('should not sign in');
        },
  );
}
