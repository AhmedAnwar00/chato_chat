import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

void main() {
  test('sdk 31 uses the black splash', () async {
    final controller = SplashController(androidSdk: () async => 31);
    final splash = await controller.load();

    expect(splash.patternPath, isNull);
    expect(splash.titleLines, ['Linoooooo', 'Chat']);
    expect(splash.primary, SplashContent.brand);
  });

  test('sdk below 31 uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => 30);
    final splash = await controller.load();

    expect(splash.patternPath, isNotNull);
    expect(splash.titleLines, ['Linoooooo', 'Chat']);
  });

  test('unknown sdk uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => null);
    final splash = await controller.load();

    expect(splash.patternPath, isNotNull);
  });
}
