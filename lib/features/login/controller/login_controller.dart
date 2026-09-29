import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_identifier.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';

enum LoginStatus { initial, loading, success, error }

class LoginController {
  LoginController({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  LoginStatus status = LoginStatus.initial;
  String? errorMessage;

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    if (status == LoginStatus.loading) {
      return;
    }
    final trimmedIdentifier = identifier.trim();
    if (trimmedIdentifier.isEmpty) {
      _fail('Enter your email or phone number.');
      return;
    }
    if (password.isEmpty) {
      _fail('Enter your password.');
      return;
    }
    if (looksLikePhoneNumber(trimmedIdentifier)) {
      _fail('Phone sign-in is not available yet.');
      return;
    }
    status = LoginStatus.loading;
    errorMessage = null;
    try {
      await _authService.signInWithEmailAndPassword(
        email: trimmedIdentifier,
        password: password,
      );
      status = LoginStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Sign in failed. Try again.');
    }
  }

  Future<void> signInWithGoogle() async {
    if (status == LoginStatus.loading) {
      return;
    }
    status = LoginStatus.loading;
    errorMessage = null;
    try {
      await _authService.signInWithGoogle();
      status = LoginStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Google sign-in failed. Try again.');
    }
  }

  void _fail(String message) {
    status = LoginStatus.error;
    errorMessage = message;
  }
}
