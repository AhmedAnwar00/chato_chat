import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
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
    await tester.enterText(find.byType(TextField).at(0), 'Ada');
    await tester.enterText(find.byType(TextField).at(1), 'a@b.com');
    await tester.enterText(find.byType(TextField).at(2), 'secret12');
    await tester.ensureVisible(find.text('Creat Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Creat Account'));
    await tester.pump();

    expect(
      find.text('An account already exists for this email.'),
      findsOneWidget,
    );
  });
}
