import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  static const _designSize = 184.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width < _designSize ? width : _designSize;
    return Image.asset(
      Assets.images.splashLogo.path,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
