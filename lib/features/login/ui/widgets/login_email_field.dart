import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_field_shell.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return LoginFieldShell(
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        cursorColor: AppColors.primary,
        style: AppTextStyles.loginField.copyWith(
          color: AppColors.inputText(brightness),
        ),
        decoration: InputDecoration(
          hintText: 'Email/Phone Number',
          hintStyle: AppTextStyles.loginField,
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }
}
