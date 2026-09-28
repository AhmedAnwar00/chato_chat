import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class SplashContent {
  const SplashContent({
    required this.logoPath,
    required this.titleLines,
    required this.primary,
    this.patternPath,
  });

  final String logoPath;
  final List<String> titleLines;
  final Color primary;
  final String? patternPath;

  factory SplashContent.aboveAndroid12() {
    return SplashContent(
      logoPath: Assets.images.splashLogo.path,
      titleLines: const ['Linoooooo', 'Chat'],
      primary: AppColors.primary,
    );
  }

  factory SplashContent.underAndroid12() {
    return SplashContent(
      logoPath: Assets.images.splashLogo.path,
      titleLines: const ['Linoooooo', 'Chat'],
      primary: AppColors.primary,
      patternPath: Assets.images.splashPattern.path,
    );
  }
}
