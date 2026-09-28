import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class LoginSignUpPrompt extends StatelessWidget {
  const LoginSignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final linkColor = AppColors.signUpLink(Theme.of(context).brightness);
    return Text.rich(
      TextSpan(
        text: 'Don\u2019t have an account? ',
        style: AppTextStyles.loginAccountPrompt,
        children: [
          TextSpan(
            text: 'Sign up now',
            style: AppTextStyles.loginSignUpLink.copyWith(
              color: linkColor,
              decorationColor: linkColor,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
