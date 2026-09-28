import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFC2F158);
  static const Color primaryDark = Color(0xFF1F1F1F);
  static const Color surfaceChat = Color(0xFFF5F2EB);
  static const Color background = Color(0xFF000000);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color subtitle = Color(0xFF61677D);
  static const Color hint = Color(0xFF7C8BA0);
  static const Color fieldFill = Color(0x1AC2F158);
  static const Color socialFill = Color(0x4DC2F158);
  static const Color lineLight = Color(0xFFE0E5EC);
  static const Color lineDark = Color(0xFF3A3A3A);
  static const Color accountPrompt = Color(0xFF828282);
  static const Color gray800 = Color(0xFF3B4054);

  static Color signInTitle(Brightness brightness) {
    return brightness == Brightness.dark ? primary : primaryDark;
  }

  static Color inputText(Brightness brightness) {
    return brightness == Brightness.dark ? surfaceLight : primaryDark;
  }

  static Color divider(Brightness brightness) {
    return brightness == Brightness.dark ? lineDark : lineLight;
  }

  static Color signUpLink(Brightness brightness) {
    return brightness == Brightness.dark ? primary : primaryDark;
  }
}
