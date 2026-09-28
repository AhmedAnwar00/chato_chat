import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_wave_badge.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_email_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_header.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_login_prompt.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_name_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_password_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_submit_button.dart';

class SignupBody extends StatelessWidget {
  const SignupBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 393),
        child: const Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    LoginWaveBadge(),
                    SizedBox(height: 30),
                    SignupHeader(),
                    SizedBox(height: 96),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          SignupNameField(),
                          SizedBox(height: 16),
                          SignupEmailField(),
                          SizedBox(height: 16),
                          SignupPasswordField(),
                        ],
                      ),
                    ),
                    SizedBox(height: 81),
                    SignupSubmitButton(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: SignupLoginPrompt(),
            ),
          ],
        ),
      ),
    );
  }
}
