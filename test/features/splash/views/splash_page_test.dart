import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/features/splash/ui/splash_page.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

void main() {
  testWidgets('light sdk 33 uses the solid splash', (tester) async {
    await _pumpSplash(tester, brightness: Brightness.light, sdk: 33);

    expect(_scaffoldColor(tester), AppColors.primary);
    expect(_titleColor(tester), AppColors.primaryDark);
    expect(_assetNames(tester), [Assets.images.splashLogo.path]);
  });

  testWidgets('light sdk 32 uses the doodle splash', (tester) async {
    await _pumpSplash(tester, brightness: Brightness.light, sdk: 32);

    expect(_scaffoldColor(tester), AppColors.surfaceChat);
    expect(_titleColor(tester), AppColors.primaryDark);
    expect(
      _assetNames(tester),
      contains(Assets.images.splashPatternLight.path),
    );
  });

  testWidgets('dark sdk 33 uses the solid splash', (tester) async {
    await _pumpSplash(tester, brightness: Brightness.dark, sdk: 33);

    expect(_scaffoldColor(tester), AppColors.background);
    expect(_titleColor(tester), AppColors.primary);
    expect(_assetNames(tester), [Assets.images.splashLogo.path]);
  });

  testWidgets('dark sdk 32 uses the doodle splash', (tester) async {
    await _pumpSplash(tester, brightness: Brightness.dark, sdk: 32);

    expect(_scaffoldColor(tester), AppColors.background);
    expect(_titleColor(tester), AppColors.primary);
    expect(_assetNames(tester), contains(Assets.images.splashPattern.path));
  });
}

Future<void> _pumpSplash(
  WidgetTester tester, {
  required Brightness brightness,
  required int sdk,
}) async {
  tester.platformDispatcher.platformBrightnessTestValue = brightness;
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
  await tester.pumpWidget(
    MaterialApp(
      home: SplashPage(
        controller: SplashController(androidSdk: () async => sdk),
      ),
    ),
  );
  await tester.pump();
}

Color? _scaffoldColor(WidgetTester tester) {
  return tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor;
}

Color? _titleColor(WidgetTester tester) {
  return tester.widget<Text>(find.text('Linoooooo')).style?.color;
}

Iterable<String> _assetNames(WidgetTester tester) {
  return tester.widgetList<Image>(find.byType(Image)).map((image) {
    final provider = image.image;
    return provider is AssetImage ? provider.assetName : '';
  });
}
