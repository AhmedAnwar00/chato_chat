import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
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
        service.signInWithEmailAndPassword(email: 'a@b.com', password: 'secret'),
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
