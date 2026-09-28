import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

class SplashBackdrop extends StatelessWidget {
  const SplashBackdrop({super.key, required this.splash});

  final SplashContent splash;

  @override
  Widget build(BuildContext context) {
    final patternPath = splash.patternPath;
    if (patternPath == null) {
      return const ColoredBox(
        color: AppColors.background,
        child: SizedBox.expand(),
      );
    }
    return SizedBox.expand(child: Image.asset(patternPath, fit: BoxFit.cover));
  }
}
