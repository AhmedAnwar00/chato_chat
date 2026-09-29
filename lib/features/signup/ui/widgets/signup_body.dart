import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_wave_badge.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_email_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_error_message.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_header.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_login_prompt.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_name_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_password_field.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_submit_button.dart';

class SignupBody extends StatelessWidget {
  const SignupBody({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.isLoading,
    this.errorMessage,
  });

  final ValueChanged<String> onEmailChanged;
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    const LoginWaveBadge(),
                    const SizedBox(height: 30),
                    const SignupHeader(),
                    const SizedBox(height: 96),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SignupNameField(),
                          const SizedBox(height: 16),
                          SignupEmailField(onChanged: onEmailChanged),
                          const SizedBox(height: 16),
                          SignupPasswordField(
                            onChanged: onPasswordChanged,
                            onSubmitted: onSubmit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (errorMessage == null)
                      const SizedBox(height: 57)
                    else
                      SignupErrorMessage(message: errorMessage!),
                    const SizedBox(height: 24),
                    SignupSubmitButton(
                      isLoading: isLoading,
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: SignupLoginPrompt(),
            ),
          ],
        ),
      ),
    );
  }
}
