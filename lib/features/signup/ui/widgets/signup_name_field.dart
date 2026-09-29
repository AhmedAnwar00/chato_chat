import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_field_shell.dart';

class SignupNameField extends StatefulWidget {
  const SignupNameField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<SignupNameField> createState() => _SignupNameFieldState();
}

class _SignupNameFieldState extends State<SignupNameField> {
  late final FocusNode _focusNode;

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
    return SignupFieldShell(
      focused: _focusNode.hasFocus,
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        cursorColor: AppColors.primary,
        style: AppTextStyles.loginField.copyWith(
          color: AppColors.inputText(brightness),
        ),
        decoration: InputDecoration(
          hintText: 'Name',
          hintStyle: AppTextStyles.loginField,
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }
}
