import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get data => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
  );
}
