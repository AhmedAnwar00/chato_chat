import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final titleColor = AppColors.signInTitle(Theme.of(context).brightness);
    return Column(
      children: [
        Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: AppTextStyles.signInTitle.copyWith(color: titleColor),
        ),
        const SizedBox(height: 16),
        Text(
          'Let’s go To discover App',
          textAlign: TextAlign.center,
          style: AppTextStyles.loginSubtitle,
        ),
      ],
    );
  }
}
