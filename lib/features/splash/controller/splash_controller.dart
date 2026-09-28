import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';

class SplashController {
  SplashController({Future<int?> Function()? androidSdk})
    : _androidSdk = androidSdk ?? _deviceSdk;

  final Future<int?> Function() _androidSdk;

  static const android12Sdk = 31;

  Future<SplashContent> load() async {
    final sdk = await _androidSdk();
    if (sdk != null && sdk >= android12Sdk) {
      return SplashContent.aboveAndroid12();
    }
    return SplashContent.underAndroid12();
  }

  static Future<int?> _deviceSdk() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    } on Object {
      return null;
    }
  }
}
