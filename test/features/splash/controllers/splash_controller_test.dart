import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';

void main() {
  test('sdk 31 uses the black splash', () async {
    final controller = SplashController(androidSdk: () async => 31);
    final showPattern = await controller.load();

    expect(showPattern, isFalse);
  });

  test('sdk below 31 uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => 30);
    final showPattern = await controller.load();

    expect(showPattern, isTrue);
  });

  test('unknown sdk uses the doodle splash', () async {
    final controller = SplashController(androidSdk: () async => null);
    final showPattern = await controller.load();

    expect(showPattern, isTrue);
  });
}
