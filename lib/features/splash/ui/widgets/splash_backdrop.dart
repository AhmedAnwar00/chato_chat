import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class SplashBackdrop extends StatelessWidget {
  const SplashBackdrop({super.key, required this.showPattern});

  final bool showPattern;

  @override
  Widget build(BuildContext context) {
    if (!showPattern) {
      return const ColoredBox(
        color: AppColors.primary,
        child: SizedBox.expand(),
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
