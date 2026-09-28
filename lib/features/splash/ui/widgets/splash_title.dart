import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key, required this.splash});

  final SplashContent splash;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.cairo(
      color: splash.primary,
      fontSize: 46.098,
      fontWeight: FontWeight.w900,
      height: 51 / 46.098,
      letterSpacing: -0.922,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final line in splash.titleLines)
          Text(line, textAlign: TextAlign.center, style: style),
      ],
    );
  }
}
