import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/theme/app_theme_controller.dart';

void main() {
  test('starts on the system theme', () {
    final controller = AppThemeController();

    expect(controller.mode, ThemeMode.system);
  });

  test('toggle from system dark selects light', () {
    final controller = AppThemeController();

    controller.toggle(Brightness.dark);

    expect(controller.mode, ThemeMode.light);
  });

  test('toggle from system light selects dark', () {
    final controller = AppThemeController();

    controller.toggle(Brightness.light);

    expect(controller.mode, ThemeMode.dark);
  });

  test('toggle flips an explicit mode', () {
    final controller = AppThemeController();
    controller.toggle(Brightness.light);

    controller.toggle(Brightness.dark);

    expect(controller.mode, ThemeMode.light);
  });

  test('notifies after toggle until disposed', () {
    var calls = 0;
    final controller = AppThemeController()..start(() => calls++);

    controller.toggle(Brightness.light);
    controller.dispose();
    controller.toggle(Brightness.dark);

    expect(calls, 1);
    expect(controller.mode, ThemeMode.light);
  });
}
