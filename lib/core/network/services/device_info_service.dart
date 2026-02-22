import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _cachedId;

  Future<String> getDeviceId() async {
    if (_cachedId != null) return _cachedId!;

    // Check if we already stored a persistent ID
    final savedId = await _storage.read(key: 'device_fingerprint');
    if (savedId != null) {
      _cachedId = savedId;
      return savedId;
    }

    String identifier = '';

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      identifier =
          '${androidInfo.model}:${androidInfo.brand}:${androidInfo.id}';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      identifier =
          '${iosInfo.model}:${iosInfo.name}:${iosInfo.identifierForVendor}';
    } else {
      identifier = 'web_or_other_platform';
    }

    // Hash the combination to create a fingerprint
    final hash = sha256.convert(utf8.encode(identifier)).toString();

    // Persist it
    await _storage.write(key: 'device_fingerprint', value: hash);
    _cachedId = hash;

    return hash;
  }

  Future<Map<String, dynamic>> getFullDeviceInfo() async {
    final deviceId = await getDeviceId();

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return {
        'device_id': deviceId,
        'device_model': info.model,
        'os_version': 'Android ${info.version.release}',
        'app_version': '1.0.0',
      };
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return {
        'device_id': deviceId,
        'device_model': info.model,
        'os_version': 'iOS ${info.systemVersion}',
        'app_version': '1.0.0',
      };
    }

    return {
      'device_id': deviceId,
      'device_model': 'Unknown',
      'os_version': 'Unknown',
      'app_version': '1.0.0',
    };
  }
}
