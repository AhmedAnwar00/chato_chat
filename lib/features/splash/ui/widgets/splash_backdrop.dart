import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class SplashBackdrop extends StatelessWidget {
  const SplashBackdrop({super.key, required this.showPattern});

  final bool showPattern;

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    if (!showPattern) {
      return ColoredBox(
        color: isDark ? AppColors.background : AppColors.primary,
        child: const SizedBox.expand(),
      );
    }
    if (isDark) {
      return SizedBox.expand(
        child: Image.asset(Assets.images.splashPattern.path, fit: BoxFit.cover),
      );
    }
    return ColoredBox(
      color: AppColors.surfaceChat,
      child: SizedBox.expand(
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(
            Assets.images.splashPatternLight.path,
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
            color: AppColors.surfaceChat,
            colorBlendMode: BlendMode.difference,
          ),
        ),
      ),
    );
  }
}
