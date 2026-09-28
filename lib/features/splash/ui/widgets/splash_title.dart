import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key, required this.splash});

  final SplashContent splash;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.splashTitle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final line in splash.titleLines)
          Text(line, textAlign: TextAlign.center, style: style),
      ],
    );
  }
}
