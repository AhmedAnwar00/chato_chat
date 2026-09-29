import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_identifier.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpController {
  SignUpController({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  SignUpStatus status = SignUpStatus.initial;
  String? errorMessage;

  Future<void> signUp({required String email, required String password}) async {
    if (status == SignUpStatus.loading) {
      return;
    }
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      _fail('Enter your email.');
      return;
    }
    if (password.isEmpty) {
      _fail('Enter your password.');
      return;
    }
    if (looksLikePhoneNumber(trimmedEmail)) {
      _fail('Sign up with an email and password.');
      return;
    }
    status = SignUpStatus.loading;
    errorMessage = null;
    try {
      await _authService.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      status = SignUpStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Sign up failed. Try again.');
    }
  }

  void _fail(String message) {
    status = SignUpStatus.error;
    errorMessage = message;
  }
}
