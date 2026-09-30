import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_identifier.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/firestore/firestore_failure.dart';
import 'package:my_chatoo_chat/core/firestore/user_firestore_service.dart';
import 'package:my_chatoo_chat/core/messaging/authenticated_device_token_store.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';
import 'package:my_chatoo_chat/features/signup/model/user_profile.dart';

enum SignUpStatus { initial, loading, success, error }

class SignUpController {
  SignUpController({
    AuthService? authService,
    UserFirestoreService? userFirestoreService,
    Future<DeviceTokenSaveResult> Function()? saveDeviceToken,
  }) : _authService = authService ?? AuthService(),
       _userFirestoreService = userFirestoreService ?? UserFirestoreService(),
       _saveDeviceToken =
           saveDeviceToken ??
           AuthenticatedDeviceTokenStore().saveForCurrentUser;

  final AuthService _authService;
  final UserFirestoreService _userFirestoreService;
  final Future<DeviceTokenSaveResult> Function() _saveDeviceToken;

  SignUpStatus status = SignUpStatus.initial;
  String? errorMessage;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (status == SignUpStatus.loading) {
      return;
    }
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    if (trimmedName.isEmpty) {
      _fail('Enter your name.');
      return;
    }
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
      final createdUser = await _authService.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      await _userFirestoreService.createUserProfile(
        UserProfile(
          uid: createdUser.uid,
          email: createdUser.email,
          name: trimmedName,
          createdAt: DateTime.now(),
        ),
      );
      await _persistDeviceToken();
      status = SignUpStatus.success;
      errorMessage = null;
    } on AuthFailure catch (failure) {
      _fail(failure.message);
    } on FirestoreFailure catch (failure) {
      _fail(failure.message);
    } on Object {
      _fail('Sign up failed. Try again.');
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
    status = SignUpStatus.error;
    errorMessage = message;
  }
}
