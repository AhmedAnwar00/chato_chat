import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
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

    await tester.pumpWidget(MaterialApp(home: LoginPage(controller: controller)));
    await tester.enterText(find.byType(TextField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret12');
    await tester.ensureVisible(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log In'));
    await tester.pump();

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
  });
}
