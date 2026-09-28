import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';

class LoginFieldShell extends StatelessWidget {
  const LoginFieldShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
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
