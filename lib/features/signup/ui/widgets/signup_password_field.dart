import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_field_shell.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class SignupPasswordField extends StatefulWidget {
  const SignupPasswordField({super.key});

  @override
  State<SignupPasswordField> createState() => _SignupPasswordFieldState();
}

class _SignupPasswordFieldState extends State<SignupPasswordField> {
  late final FocusNode _focusNode;
  var _obscure = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final icon = brightness == Brightness.dark
        ? Assets.images.loginVisibilityOffDark
        : Assets.images.loginVisibilityOffLight;
    return SignupFieldShell(
      focused: _focusNode.hasFocus,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              cursorColor: AppColors.primary,
              style: AppTextStyles.signUpPassword,
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
