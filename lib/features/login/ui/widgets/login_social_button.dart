import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class LoginSocialButton extends StatelessWidget {
  const LoginSocialButton({super.key, required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final labelColor = AppColors.signInTitle(Theme.of(context).brightness);
    return Material(
      color: AppColors.socialFill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              Text(
                label,
                style: AppTextStyles.loginSocial.copyWith(color: labelColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
