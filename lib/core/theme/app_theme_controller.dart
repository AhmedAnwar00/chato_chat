import 'package:flutter/material.dart';

class AppThemeController {
  ThemeMode mode = ThemeMode.system;

  void Function()? _onChanged;

  void start(void Function() onChanged) {
    _onChanged = onChanged;
  }

  void toggle(Brightness brightness) {
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system && brightness == Brightness.dark);
    mode = isDark ? ThemeMode.light : ThemeMode.dark;
    _onChanged?.call();
  }

  void dispose() {
    _onChanged = null;
  }
}
