import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/auth/created_auth_user.dart';
import 'package:my_chatoo_chat/core/firestore/user_firestore_service.dart';
import 'package:my_chatoo_chat/core/messaging/device_token_save_result.dart';
import 'package:my_chatoo_chat/features/signup/controller/signup_controller.dart';
import 'package:my_chatoo_chat/features/signup/ui/signup_page.dart';

void main() {
  testWidgets('failed sign-up shows the error text', (tester) async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              throw FirebaseAuthException(code: 'email-already-in-use');
            },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: SignupPage(controller: controller)),
    );
    await _enterAccount(tester);
    await tester.tap(find.text('Creat Account'));
    await tester.pump();

    expect(
      find.text('An account already exists for this email.'),
      findsNWidgets(2),
    );
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('empty name shows one validation snackbar', (tester) async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              fail('should not create a user');
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({required String uid, required Map<String, dynamic> data}) async {
              fail('should not write a profile');
            },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: SignupPage(controller: controller)),
    );
    await tester.ensureVisible(find.text('Creat Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Creat Account'));
    await tester.pump();

    expect(find.text('Enter your name.'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('profile failure shows one firestore snackbar', (tester) async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              return const CreatedAuthUser(uid: 'user-1', email: 'a@b.com');
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({required String uid, required Map<String, dynamic> data}) async {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'unavailable',
              );
            },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: SignupPage(controller: controller)),
    );
    await _enterAccount(tester);
    await tester.tap(find.text('Creat Account'));
    await tester.pump();

    expect(find.text('Check your connection and try again.'), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);
  });

  testWidgets('successful sign-up shows one snackbar and stays on the page', (
    tester,
  ) async {
    final controller = SignUpController(
      authService: AuthService(
        createUserWithEmailAndPassword:
            ({required String email, required String password}) async {
              return CreatedAuthUser(uid: 'user-1', email: email);
            },
      ),
      userFirestoreService: UserFirestoreService(
        writeUser:
            ({
              required String uid,
              required Map<String, dynamic> data,
            }) async {},
      ),
      saveDeviceToken: _savedToken,
    );

    await tester.pumpWidget(
      MaterialApp(home: SignupPage(controller: controller)),
    );
    await _enterAccount(tester);
    await tester.tap(find.text('Creat Account'));
    await tester.pump();

    expect(find.text('Account created.'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(SignupPage), findsOneWidget);
  });
}

Future<DeviceTokenSaveResult> _savedToken() async {
  return const DeviceTokenSaveResult(DeviceTokenSaveStatus.saved);
}

Future<void> _enterAccount(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'Ada');
  await tester.enterText(find.byType(TextField).at(1), 'a@b.com');
  await tester.enterText(find.byType(TextField).at(2), 'secret12');
  await tester.ensureVisible(find.text('Creat Account'));
  await tester.pumpAndSettle();
}
