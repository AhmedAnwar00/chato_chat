import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_body.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.background : AppColors.surfaceLight;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: background,
          ),
      child: Scaffold(
        backgroundColor: background,
        body: const SafeArea(child: SignupBody()),
      ),
    );
  }
}
