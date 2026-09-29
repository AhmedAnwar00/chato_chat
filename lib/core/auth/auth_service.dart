import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/created_auth_user.dart';

typedef CreateEmailPasswordRequest =
    Future<CreatedAuthUser> Function({
      required String email,
      required String password,
    });

typedef EmailPasswordRequest =
    Future<void> Function({required String email, required String password});

typedef GoogleIdTokenRequest = Future<String?> Function();

typedef FacebookAccessTokenRequest = Future<String?> Function();

typedef SignInWithCredentialRequest =
    Future<void> Function(AuthCredential credential);

class AuthService {
  AuthService({
    CreateEmailPasswordRequest? createUserWithEmailAndPassword,
    EmailPasswordRequest? signInWithEmailAndPassword,
    GoogleIdTokenRequest? requestGoogleIdToken,
    FacebookAccessTokenRequest? requestFacebookAccessToken,
    SignInWithCredentialRequest? signInWithCredential,
  }) : _createUser = createUserWithEmailAndPassword ?? _firebaseCreateUser,
       _signIn = signInWithEmailAndPassword ?? _firebaseSignIn,
       _requestGoogleIdToken = requestGoogleIdToken ?? _firebaseGoogleIdToken,
       _requestFacebookAccessToken =
           requestFacebookAccessToken ?? _firebaseFacebookAccessToken,
       _signInWithCredential =
           signInWithCredential ?? _firebaseSignInWithCredential;

  final CreateEmailPasswordRequest _createUser;
  final EmailPasswordRequest _signIn;
  final GoogleIdTokenRequest _requestGoogleIdToken;
  final FacebookAccessTokenRequest _requestFacebookAccessToken;
  final SignInWithCredentialRequest _signInWithCredential;

  static Future<void>? _googleInitialize;

  Future<CreatedAuthUser> createUserWithEmailAndPassword({
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

  Future<void> signInWithGoogle() async {
    try {
      final idToken = await _requestGoogleIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw const AuthFailure('Google sign-in failed. Try again.');
      }
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _signInWithCredential(credential);
    } on GoogleSignInException catch (error) {
      throw AuthFailure(_googleSignInMessage(error.code));
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_googleAuthMessage(error.code));
    } on AuthFailure {
      rethrow;
    } on Object {
      throw const AuthFailure('Google sign-in failed. Try again.');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final accessToken = await _requestFacebookAccessToken();
      if (accessToken == null) {
        throw const AuthFailure('Facebook sign-in was cancelled.');
      }
      if (accessToken.isEmpty) {
        throw const AuthFailure('Facebook sign-in failed. Try again.');
      }
      final credential = FacebookAuthProvider.credential(accessToken);
      await _signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(_facebookAuthMessage(error.code));
    } on AuthFailure {
      rethrow;
    } on Object {
      throw const AuthFailure('Facebook sign-in failed. Try again.');
    }
  }

  Future<T> _guard<T>(
    Future<T> Function() request,
    String Function(String code) messageForCode,
  ) async {
    try {
      return await request();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(messageForCode(error.code));
    } on AuthFailure {
      rethrow;
    } on Object {
      throw AuthFailure(messageForCode(''));
    }
  }

  static Future<CreatedAuthUser> _firebaseCreateUser({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user == null) {
      throw const AuthFailure('Sign up failed. Try again.');
    }
    return CreatedAuthUser(uid: user.uid, email: user.email ?? email);
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

  static Future<void> _ensureGoogleInitialized() {
    final pending = _googleInitialize;
    if (pending != null) {
      return pending;
    }
    late final Future<void> created;
    created = GoogleSignIn.instance.initialize().catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      if (identical(_googleInitialize, created)) {
        _googleInitialize = null;
      }
      Error.throwWithStackTrace(error, stackTrace);
    });
    _googleInitialize = created;
    return created;
  }

  static Future<String?> _firebaseGoogleIdToken() async {
    await _ensureGoogleInitialized();
    final account = await GoogleSignIn.instance.authenticate();
    return account.authentication.idToken;
  }

  static Future<String?> _firebaseFacebookAccessToken() async {
    final result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
      loginTracking: LoginTracking.enabled,
    );
    return switch (result.status) {
      LoginStatus.cancelled => null,
      LoginStatus.success => result.accessToken?.tokenString ?? '',
      LoginStatus.failed || LoginStatus.operationInProgress =>
        throw const AuthFailure('Facebook sign-in failed. Try again.'),
    };
  }

  static Future<void> _firebaseSignInWithCredential(
    AuthCredential credential,
  ) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static String _googleSignInMessage(GoogleSignInExceptionCode code) {
    return switch (code) {
      GoogleSignInExceptionCode.canceled => 'Google sign-in was cancelled.',
      GoogleSignInExceptionCode.interrupted =>
        'Google sign-in was interrupted. Try again.',
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError =>
        'Google sign-in is not available.',
      _ => 'Google sign-in failed. Try again.',
    };
  }

  static String _googleAuthMessage(String code) {
    return switch (code) {
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'Check your connection and try again.',
      'operation-not-allowed' => 'Google sign-in is not available.',
      'account-exists-with-different-credential' =>
        'This email is already used with another sign-in method.',
      _ => 'Google sign-in failed. Try again.',
    };
  }

  static String _facebookAuthMessage(String code) {
    return switch (code) {
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many attempts. Try again later.',
      'network-request-failed' => 'Check your connection and try again.',
      'operation-not-allowed' => 'Facebook sign-in is not available.',
      'account-exists-with-different-credential' =>
        'This email is already used with another sign-in method.',
      _ => 'Facebook sign-in failed. Try again.',
    };
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
