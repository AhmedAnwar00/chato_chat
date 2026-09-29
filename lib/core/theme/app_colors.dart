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
  static const Color chatOutgoingDark = Color(0xFF144D37);
  static const Color chatQuoteAccent = Color(0xFFD42A66);
  static const Color chatHeaderDark = Color(0xFF0A0A0A);
  static const Color chatComposerFieldDark = Color(0xFF161616);
  static const Color chatComposerDark = Color(0xCC0A0A0A);
  static const Color chatReactionBorderDark = Color(0xFF353535);
  static const Color chatReactionBorderLight = Color(0xFFF0E9DF);
  static const Color chatQuoteFill = Color(0x0A0A0A0A);
  static const Color chatTimeOnDark = Color(0x80FFFFFF);
  static const Color chatTimeOnLight = Color(0x80000000);
  static const Color chatBorderOnDark = Color(0x0FFFFFFF);
  static const Color chatBorderOnLight = Color(0x0F000000);

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

  static Color chatIncoming(Brightness brightness) {
    return brightness == Brightness.dark ? primaryDark : surfaceLight;
  }

  static Color chatOutgoing(Brightness brightness) {
    return brightness == Brightness.dark ? chatOutgoingDark : primary;
  }

  static Color chatBubbleText(Brightness brightness) {
    return brightness == Brightness.dark ? surfaceLight : primaryDark;
  }

  static Color chatTime(Brightness brightness) {
    return brightness == Brightness.dark ? chatTimeOnDark : chatTimeOnLight;
  }

  static Color chatHeader(Brightness brightness) {
    return brightness == Brightness.dark ? chatHeaderDark : surfaceChat;
  }

  static Color chatComposerBar(Brightness brightness) {
    return brightness == Brightness.dark ? chatComposerDark : surfaceChat;
  }

  static Color chatComposerField(Brightness brightness) {
    return brightness == Brightness.dark ? chatComposerFieldDark : surfaceLight;
  }

  static Color chatReactionFill(Brightness brightness) {
    return brightness == Brightness.dark ? primaryDark : surfaceLight;
  }

  static Color chatReactionBorder(Brightness brightness) {
    return brightness == Brightness.dark
        ? chatReactionBorderDark
        : chatReactionBorderLight;
  }

  static Color chatBubbleBorder(
    Brightness brightness, {
    required bool outgoing,
  }) {
    if (brightness == Brightness.dark && outgoing) {
      return chatBorderOnDark;
    }
    return chatBorderOnLight;
  }
}
