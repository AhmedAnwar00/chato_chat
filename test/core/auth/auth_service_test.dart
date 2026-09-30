import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';

void main() {
  test('maps sign-up Firebase errors', () async {
    const cases = {
      'email-already-in-use': 'An account already exists for this email.',
      'invalid-email': 'Enter a valid email address.',
      'weak-password': 'Use a stronger password.',
      'operation-not-allowed': 'Email sign-up is not available.',
      'too-many-requests': 'Too many attempts. Try again later.',
      'network-request-failed': 'Check your connection and try again.',
      'unknown': 'Sign up failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: entry.key);
            },
      );

      await expectLater(
        service.createUserWithEmailAndPassword(
          email: 'a@b.com',
          password: 'secret',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('maps sign-in Firebase errors', () async {
    const cases = {
      'invalid-email': 'Enter a valid email address.',
      'invalid-credential': 'Email or password is incorrect.',
      'user-not-found': 'Email or password is incorrect.',
      'wrong-password': 'Email or password is incorrect.',
      'user-disabled': 'This account has been disabled.',
      'too-many-requests': 'Too many attempts. Try again later.',
      'network-request-failed': 'Check your connection and try again.',
      'unknown': 'Sign in failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: entry.key);
            },
      );

      await expectLater(
        service.signInWithEmailAndPassword(
          email: 'a@b.com',
          password: 'secret',
        ),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('signs in with the Google credential', () async {
    AuthCredential? captured;
    final service = AuthService(
      requestGoogleIdToken: () async => 'google-id-token',
      signInWithCredential: (credential) async {
        captured = credential;
      },
    );

    await service.signInWithGoogle();

    final credential = captured! as OAuthCredential;
    expect(credential.providerId, 'google.com');
    expect(credential.idToken, 'google-id-token');
  });

  test('missing Google token does not call Firebase', () async {
    for (final idToken in [null, '']) {
      var calls = 0;
      final service = AuthService(
        requestGoogleIdToken: () async => idToken,
        signInWithCredential: (_) async {
          calls++;
        },
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            'Google sign-in failed. Try again.',
          ),
        ),
      );
      expect(calls, 0);
    }
  });

  test('maps Google sign-in client errors', () async {
    const cases = {
      GoogleSignInExceptionCode.canceled: 'Google sign-in was cancelled.',
      GoogleSignInExceptionCode.interrupted:
          'Google sign-in was interrupted. Try again.',
      GoogleSignInExceptionCode.clientConfigurationError:
          'Google sign-in is not available.',
      GoogleSignInExceptionCode.providerConfigurationError:
          'Google sign-in is not available.',
      GoogleSignInExceptionCode.uiUnavailable:
          'Google sign-in failed. Try again.',
      GoogleSignInExceptionCode.unknownError:
          'Google sign-in failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        requestGoogleIdToken: () async {
          throw GoogleSignInException(code: entry.key);
        },
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('maps Google Firebase errors', () async {
    const cases = {
      'invalid-credential': 'Google sign-in failed. Try again.',
      'user-disabled': 'This account has been disabled.',
      'too-many-requests': 'Too many attempts. Try again later.',
      'network-request-failed': 'Check your connection and try again.',
      'operation-not-allowed': 'Google sign-in is not available.',
      'account-exists-with-different-credential':
          'This email is already used with another sign-in method.',
      'unknown': 'Google sign-in failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        requestGoogleIdToken: () async => 'google-id-token',
        signInWithCredential: (_) async {
          throw FirebaseAuthException(code: entry.key);
        },
      );

      await expectLater(
        service.signInWithGoogle(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('signs in with the Facebook credential', () async {
    AuthCredential? captured;
    final service = AuthService(
      requestFacebookAccessToken: () async => 'facebook-access-token',
      signInWithCredential: (credential) async {
        captured = credential;
      },
    );

    await service.signInWithFacebook();

    final credential = captured! as OAuthCredential;
    expect(credential.providerId, 'facebook.com');
    expect(credential.accessToken, 'facebook-access-token');
  });

  test('missing Facebook token does not call Firebase', () async {
    const cases = {
      null: 'Facebook sign-in was cancelled.',
      '': 'Facebook sign-in failed. Try again.',
    };

    for (final entry in cases.entries) {
      var calls = 0;
      final service = AuthService(
        requestFacebookAccessToken: () async => entry.key,
        signInWithCredential: (_) async {
          calls++;
        },
      );

      await expectLater(
        service.signInWithFacebook(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
      expect(calls, 0);
    }
  });

  test('maps Facebook Firebase errors', () async {
    const cases = {
      'invalid-credential': 'Facebook sign-in failed. Try again.',
      'user-disabled': 'This account has been disabled.',
      'too-many-requests': 'Too many attempts. Try again later.',
      'network-request-failed': 'Check your connection and try again.',
      'operation-not-allowed': 'Facebook sign-in is not available.',
      'account-exists-with-different-credential':
          'This email is already used with another sign-in method.',
      'unknown': 'Facebook sign-in failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        requestFacebookAccessToken: () async => 'facebook-access-token',
        signInWithCredential: (_) async {
          throw FirebaseAuthException(code: entry.key);
        },
      );

      await expectLater(
        service.signInWithFacebook(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('signs out the current user', () async {
    var calls = 0;
    final service = AuthService(
      signOut: () async {
        calls++;
      },
    );

    await service.signOut();

    expect(calls, 1);
  });

  test('maps sign-out Firebase errors', () async {
    const cases = {
      'network-request-failed': 'Check your connection and try again.',
      'too-many-requests': 'Too many attempts. Try again later.',
      'unknown': 'Sign out failed. Try again.',
    };

    for (final entry in cases.entries) {
      final service = AuthService(
        signOut: () async {
          throw FirebaseAuthException(code: entry.key);
        },
      );

      await expectLater(
        service.signOut(),
        throwsA(
          isA<AuthFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });
}
