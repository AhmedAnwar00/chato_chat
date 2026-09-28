import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get splashTitle => GoogleFonts.cairo(
    color: AppColors.primary,
    fontSize: 46.098,
    fontWeight: FontWeight.w900,
    height: 51 / 46.098,
    letterSpacing: -0.922,
  );
}
