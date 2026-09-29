import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/features/fake_home/ui/fake_home_page.dart';
import 'package:my_chatoo_chat/features/login/controller/login_controller.dart';
import 'package:my_chatoo_chat/features/login/ui/login_page.dart';

void main() {
  testWidgets('failed sign-in shows the error text', (tester) async {
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'wrong-password');
            },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: LoginPage(controller: controller)),
    );
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret12');
    await tester.ensureVisible(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pump();

    expect(find.text('Email or password is incorrect.'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('successful sign-in shows one snackbar and opens home', (
    tester,
  ) async {
    final controller = LoginController(
      authService: AuthService(
        signInWithEmailAndPassword:
            ({required String email, required String password}) async {},
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(controller: controller),
        routes: {AppRoute.fakeHome.path: (_) => const FakeHomePage()},
      ),
    );
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret12');
    await tester.ensureVisible(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Login Successful'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(FakeHomePage), findsOneWidget);
  });

  testWidgets('failed Google sign-in shows the error snackbar', (tester) async {
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () async {
          throw const GoogleSignInException(
            code: GoogleSignInExceptionCode.canceled,
          );
        },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: LoginPage(controller: controller)),
    );
    await tester.ensureVisible(find.text('Google'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Google'));
    await tester.pump();

    expect(find.text('Google sign-in was cancelled.'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(FakeHomePage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('successful Google sign-in shows one snackbar and opens home', (
    tester,
  ) async {
    final controller = LoginController(
      authService: AuthService(
        requestGoogleIdToken: () async => 'google-id-token',
        signInWithCredential: (_) async {},
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(controller: controller),
        routes: {AppRoute.fakeHome.path: (_) => const FakeHomePage()},
      ),
    );
    await tester.ensureVisible(find.text('Google'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Google'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Login Successful'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(FakeHomePage), findsOneWidget);
  });
}
