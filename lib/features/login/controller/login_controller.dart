import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_identifier.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/messaging/authenticated_device_token_store.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';

enum LoginStatus { initial, loading, success, error }

class LoginController {
  LoginController({
    AuthService? authService,
    Future<DeviceTokenSaveResult> Function()? saveDeviceToken,
  }) : _authService = authService ?? AuthService(),
       _saveDeviceToken =
           saveDeviceToken ??
           AuthenticatedDeviceTokenStore().saveForCurrentUser;

  final AuthService _authService;
  final Future<DeviceTokenSaveResult> Function() _saveDeviceToken;

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
      await _persistDeviceToken();
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
      await _persistDeviceToken();
      status = LoginStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Google sign-in failed. Try again.');
    }
  }

  Future<void> signInWithFacebook() async {
    if (status == LoginStatus.loading) {
      return;
    }
    status = LoginStatus.loading;
    errorMessage = null;
    try {
      await _authService.signInWithFacebook();
      await _persistDeviceToken();
      status = LoginStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Facebook sign-in failed. Try again.');
    }
  }

  Future<void> _persistDeviceToken() async {
    try {
      await _saveDeviceToken();
    } on Object {
      return;
    }
  }

  void _fail(String message) {
    status = LoginStatus.error;
    errorMessage = message;
  }
}
