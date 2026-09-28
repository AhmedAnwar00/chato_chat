import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, required this.splash});

  final SplashContent splash;

  static const _designSize = 184.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width < _designSize ? width : _designSize;
    return Image.asset(
      splash.logoPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
