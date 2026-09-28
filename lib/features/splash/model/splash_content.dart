import 'dart:ui';

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

  static const Color brand = Color(0xFFC2F158);

  factory SplashContent.aboveAndroid12() {
    return SplashContent(
      logoPath: Assets.images.splashLogo.path,
      titleLines: const ['Linoooooo', 'Chat'],
      primary: brand,
    );
  }

  factory SplashContent.underAndroid12() {
    return SplashContent(
      logoPath: Assets.images.splashLogo.path,
      titleLines: const ['Linoooooo', 'Chat'],
      primary: brand,
      patternPath: Assets.images.splashPattern.path,
    );
  }
}
