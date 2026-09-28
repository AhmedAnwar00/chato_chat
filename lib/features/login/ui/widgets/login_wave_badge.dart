import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class LoginWaveBadge extends StatelessWidget {
  const LoginWaveBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          Assets.images.loginClaps.path,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
