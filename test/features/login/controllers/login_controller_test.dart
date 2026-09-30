import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';
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
      saveDeviceToken: _savedToken,
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
      saveDeviceToken: _savedToken,
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

  test('Google success clears the error', () async {
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () async => 'google-id-token',
        signInWithCredential: (_) async {},
      ),
      saveDeviceToken: _savedToken,
    );

    await controller.signInWithGoogle();

    expect(controller.status, LoginStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('Google failure sets the service message', () async {
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () async => 'google-id-token',
        signInWithCredential: (_) async {
          throw FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          );
        },
      ),
    );

    await controller.signInWithGoogle();

    expect(controller.status, LoginStatus.error);
    expect(
      controller.errorMessage,
      'This email is already used with another sign-in method.',
    );
  });

  test('Google cancellation sets a friendly message', () async {
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () async {
          throw const GoogleSignInException(
            code: GoogleSignInExceptionCode.canceled,
          );
        },
      ),
    );

    await controller.signInWithGoogle();

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Google sign-in was cancelled.');
  });

  test('ignores a second Google call while loading', () async {
    final completer = Completer<String?>();
    var calls = 0;
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () {
          calls++;
          return completer.future;
        },
        signInWithCredential: (_) async {},
      ),
      saveDeviceToken: _savedToken,
    );

    final first = controller.signInWithGoogle();
    final second = controller.signInWithGoogle();
    expect(controller.status, LoginStatus.loading);
    expect(calls, 1);

    completer.complete('google-id-token');
    await first;
    await second;

    expect(controller.status, LoginStatus.success);
    expect(calls, 1);
  });

  test('Facebook success clears the error', () async {
    final controller = LoginController(
      authService: AuthService(
        requestFacebookAccessToken: () async => 'facebook-access-token',
        signInWithCredential: (_) async {},
      ),
      saveDeviceToken: _savedToken,
    );

    await controller.signInWithFacebook();

    expect(controller.status, LoginStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('Facebook failure sets the service message', () async {
    final controller = LoginController(
      authService: AuthService(
        requestFacebookAccessToken: () async => 'facebook-access-token',
        signInWithCredential: (_) async {
          throw FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          );
        },
      ),
    );

    await controller.signInWithFacebook();

    expect(controller.status, LoginStatus.error);
    expect(
      controller.errorMessage,
      'This email is already used with another sign-in method.',
    );
  });

  test('Facebook cancellation sets a friendly message', () async {
    final controller = LoginController(
      authService: AuthService(requestFacebookAccessToken: () async => null),
    );

    await controller.signInWithFacebook();

    expect(controller.status, LoginStatus.error);
    expect(controller.errorMessage, 'Facebook sign-in was cancelled.');
  });

  test('ignores a second Facebook call while loading', () async {
    final completer = Completer<String?>();
    var calls = 0;
    final controller = LoginController(
      authService: AuthService(
        requestFacebookAccessToken: () {
          calls++;
          return completer.future;
        },
        signInWithCredential: (_) async {},
      ),
      saveDeviceToken: _savedToken,
    );

    final first = controller.signInWithFacebook();
    final second = controller.signInWithFacebook();
    expect(controller.status, LoginStatus.loading);
    expect(calls, 1);

    completer.complete('facebook-access-token');
    await first;
    await second;

    expect(controller.status, LoginStatus.success);
    expect(calls, 1);
  });

  test('email success still succeeds when saving the token fails', () async {
    var saves = 0;
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {},
      ),
      saveDeviceToken: () async {
        saves++;
        return const DeviceTokenSaveResult(DeviceTokenSaveStatus.failed);
      },
    );

    await controller.signIn(identifier: 'a@b.com', password: 'secret');

    expect(saves, 1);
    expect(controller.status, LoginStatus.success);
    expect(controller.errorMessage, isNull);
  });

  test('email failure does not save the device token', () async {
    var saves = 0;
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'wrong-password');
            },
      ),
      saveDeviceToken: () async {
        saves++;
        return const DeviceTokenSaveResult(DeviceTokenSaveStatus.saved);
      },
    );

    await controller.signIn(identifier: 'a@b.com', password: 'secret');

    expect(saves, 0);
    expect(controller.status, LoginStatus.error);
  });

  test('a thrown token save does not fail login', () async {
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {},
      ),
      saveDeviceToken: () async => throw StateError('database down'),
    );

    await controller.signIn(identifier: 'a@b.com', password: 'secret');

    expect(controller.status, LoginStatus.success);
    expect(controller.errorMessage, isNull);
  });
}

Future<DeviceTokenSaveResult> _savedToken() async {
  return const DeviceTokenSaveResult(DeviceTokenSaveStatus.saved);
}

AuthService _failingService() {
  return AuthService(
    signInWithEmailAndPassword:
        ({required String email, required String password}) async {
          fail('should not sign in');
        },
  );
}
