import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final titleColor = AppColors.signInTitle(Theme.of(context).brightness);
    return Column(
      children: [
        Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style: AppTextStyles.signUpTitle.copyWith(color: titleColor),
        ),
        const SizedBox(height: 16),
        Text(
          'Let’s make New Account',
          textAlign: TextAlign.center,
          style: AppTextStyles.loginSubtitle,
        ),
      ],
    );
  }
}
