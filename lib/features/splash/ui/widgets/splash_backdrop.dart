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
        color: AppColors.background,
        child: SizedBox.expand(),
      );
    }
    return SizedBox.expand(
      child: Image.asset(Assets.images.splashPattern.path, fit: BoxFit.cover),
    );
  }
}
