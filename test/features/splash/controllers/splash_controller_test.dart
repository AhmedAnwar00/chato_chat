import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';

void main() {
  test('sdk 33 uses the solid splash', () async {
    final controller = SplashController(androidSdk: () async => 33);
    final showPattern = await controller.load();

    expect(showPattern, isFalse);
  });

  test('sdk below 33 uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => 32);
    final showPattern = await controller.load();

    expect(showPattern, isTrue);
  });

  test('unknown sdk uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => null);
    final showPattern = await controller.load();

    expect(showPattern, isTrue);
  });
}
