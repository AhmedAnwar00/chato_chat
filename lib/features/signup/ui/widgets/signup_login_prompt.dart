import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class SignupLoginPrompt extends StatefulWidget {
  const SignupLoginPrompt({super.key});

  @override
  State<SignupLoginPrompt> createState() => _SignupLoginPromptState();
}

class _SignupLoginPromptState extends State<SignupLoginPrompt> {
  late final TapGestureRecognizer _loginTap;

  @override
  void initState() {
    super.initState();
    _loginTap = TapGestureRecognizer()..onTap = _openLogin;
  }

  @override
  void dispose() {
    _loginTap.dispose();
    super.dispose();
  }

  void _openLogin() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    navigator.pushReplacementNamed(AppRoute.login.path);
  }

  @override
  Widget build(BuildContext context) {
    final linkColor = AppColors.signUpLink(Theme.of(context).brightness);
    return Text.rich(
      TextSpan(
        text: 'Have an account already? ',
        style: AppTextStyles.loginAccountPrompt,
        children: [
          TextSpan(
            text: 'Log in',
            style: AppTextStyles.loginSignUpLink.copyWith(
              color: linkColor,
              decorationColor: linkColor,
            ),
            recognizer: _loginTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
