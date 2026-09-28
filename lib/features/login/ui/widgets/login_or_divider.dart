import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class LoginOrDivider extends StatelessWidget {
  const LoginOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final lineColor = AppColors.divider(Theme.of(context).brightness);
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Or', style: AppTextStyles.loginOr),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }
}
