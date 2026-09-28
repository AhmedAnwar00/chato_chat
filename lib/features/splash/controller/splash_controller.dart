import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class SplashController {
  SplashController({Future<int?> Function()? androidSdk})
    : _androidSdk = androidSdk ?? _deviceSdk;

  final Future<int?> Function() _androidSdk;

  static const android13Sdk = 33;

  Future<bool> load() async {
    final sdk = await _androidSdk();
    if (sdk != null && sdk >= android13Sdk) {
      return false;
    }
    return true;
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
