import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_field_shell.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class LoginPasswordField extends StatefulWidget {
  const LoginPasswordField({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  @override
  State<LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<LoginPasswordField> {
  var _obscure = true;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final icon = brightness == Brightness.dark
        ? Assets.images.loginVisibilityOffDark
        : Assets.images.loginVisibilityOffLight;
    return LoginFieldShell(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: widget.onChanged,
              onSubmitted: (_) => widget.onSubmitted(),
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              cursorColor: AppColors.primary,
              style: AppTextStyles.loginField.copyWith(
                color: AppColors.inputText(brightness),
              ),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: AppTextStyles.loginField,
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: icon.svg(width: 24, height: 24),
          ),
        ],
      ),
    );
  }
}
