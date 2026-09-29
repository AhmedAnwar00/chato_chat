import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_email_field.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_error_message.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_header.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_or_divider.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_password_field.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_sign_up_prompt.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_social_row.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_submit_button.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_wave_badge.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.onIdentifierChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
  });

  final ValueChanged<String> onIdentifierChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 393),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    const LoginWaveBadge(),
                    const SizedBox(height: 30),
                    const LoginHeader(),
                    const SizedBox(height: 60),
                    LoginEmailField(onChanged: onIdentifierChanged),
                    const SizedBox(height: 16),
                    LoginPasswordField(
                      onChanged: onPasswordChanged,
                      onSubmitted: onSubmit,
                    ),
                    const SizedBox(height: 24),
                    if (errorMessage == null)
                      const SizedBox(height: 57)
                    else
                      LoginErrorMessage(message: errorMessage!),
                    const SizedBox(height: 24),
                    LoginSubmitButton(isLoading: isLoading, onPressed: onSubmit),
                    const SizedBox(height: 32),
                    const LoginOrDivider(),
                    const SizedBox(height: 39),
                    const LoginSocialRow(),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: LoginSignUpPrompt(),
            ),
          ],
        ),
      ),
    );
  }
}
