import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get splashTitle => GoogleFonts.cairo(
    color: AppColors.primaryDark,
    fontSize: 46.098,
    fontWeight: FontWeight.w900,
    height: 51 / 46.098,
    letterSpacing: -0.922,
  );

  static TextStyle get signInTitle => GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    height: 40 / 32,
  );

  static TextStyle get loginSubtitle => GoogleFonts.poppins(
    color: AppColors.subtitle,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
  );

  static TextStyle get loginField => GoogleFonts.poppins(
    color: AppColors.hint,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle get loginButton => GoogleFonts.cairo(
    color: AppColors.primaryDark,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    height: 24 / 16,
  );

  static TextStyle get loginOr => GoogleFonts.poppins(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
  );

  static TextStyle get loginSocial => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );
}
