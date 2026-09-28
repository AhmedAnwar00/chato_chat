import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_email_field.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_header.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_or_divider.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_password_field.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_sign_up_prompt.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_social_row.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_submit_button.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_wave_badge.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

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
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    LoginWaveBadge(),
                    SizedBox(height: 30),
                    LoginHeader(),
                    SizedBox(height: 60),
                    LoginEmailField(),
                    SizedBox(height: 16),
                    LoginPasswordField(),
                    SizedBox(height: 81),
                    LoginSubmitButton(),
                    SizedBox(height: 32),
                    LoginOrDivider(),
                    SizedBox(height: 39),
                    LoginSocialRow(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: LoginSignUpPrompt(),
            ),
          ],
        ),
      ),
    );
  }
}
