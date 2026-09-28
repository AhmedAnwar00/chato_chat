import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';

class SignupFieldShell extends StatelessWidget {
  const SignupFieldShell({
    super.key,
    required this.child,
    required this.focused,
  });

  final Widget child;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: focused ? AppColors.primary : Colors.transparent,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: child,
        ),
      ),
    );
  }
}
