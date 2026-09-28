import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final style = AppTextStyles.splashTitle.copyWith(
      color: isDark ? AppColors.primary : AppColors.primaryDark,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Linoooooo', textAlign: TextAlign.center, style: style),
        Text('Chat', textAlign: TextAlign.center, style: style),
      ],
    );
  }
}
