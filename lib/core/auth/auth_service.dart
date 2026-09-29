import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chatoo_chat/core/auth/auth_failure.dart';

typedef EmailPasswordRequest = Future<void> Function({
  required String email,
  required String password,
});

class AuthService {
  AuthService({
    EmailPasswordRequest? createUserWithEmailAndPassword,
    EmailPasswordRequest? signInWithEmailAndPassword,
  }) : _createUser = createUserWithEmailAndPassword ?? _firebaseCreateUser,
       _signIn = signInWithEmailAndPassword ?? _firebaseSignIn;

  final EmailPasswordRequest _createUser;
  final EmailPasswordRequest _signIn;

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _createUser(email: email, password: password),
      _signUpMessage,
    );
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _guard(
      () => _signIn(email: email, password: password),
      _signInMessage,
    );
  }

  Future<void> _guard(
    Future<void> Function() request,
    String Function(String code) messageForCode,
  ) async {
    try {
      await request();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(messageForCode(error.code));
    } on AuthFailure {
      rethrow;
    } on Object {
      throw AuthFailure(messageForCode(''));
    }
  }

  static Future<void> _firebaseCreateUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> _firebaseSignIn({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static String _signUpMessage(String code) {
    return switch (code) {
      'email-already-in-use' => 'An account already exists for this email.',
      'invalid-email' => 'Enter a valid email address.',
      'weak-password' => 'Use a stronger password.',
      'operation-not-allowed' => 'Email sign-up is not available.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'Check your connection and try again.',
      _ => 'Sign up failed. Try again.',
    };
  }

  static String _signInMessage(String code) {
    return switch (code) {
      'invalid-email' => 'Enter a valid email address.',
      'invalid-credential' ||
      'user-not-found' ||
      'wrong-password' => 'Email or password is incorrect.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'Check your connection and try again.',
      _ => 'Sign in failed. Try again.',
    };
  }
}
