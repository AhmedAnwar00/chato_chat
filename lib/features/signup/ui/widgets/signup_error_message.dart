import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class SignupErrorMessage extends StatelessWidget {
  const SignupErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyles.loginSubtitle.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
