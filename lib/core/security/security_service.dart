import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_device/safe_device.dart';
import '../network/services/device_info_service.dart';

enum SecurityAnomalyType { drift, hijack, insecureDevice }

class SecurityAnomaly {
  final SecurityAnomalyType type;
  final String message;
  SecurityAnomaly(this.type, this.message);
}

class SecurityService {
  final FlutterSecureStorage _storage;
  final DeviceInfoService _deviceInfo;

  static const String _sessionKeyKey = 'security_session_key';
  static const String _sessionRegionKey = 'security_session_region';
  static const String _sessionBindingKey = 'security_session_binding';
  static const String _masterSecretKey = 'security_master_secret';

  final _anomalyController = StreamController<SecurityAnomaly>.broadcast();
  Stream<SecurityAnomaly> get anomalyStream => _anomalyController.stream;

  void reportAnomaly(SecurityAnomalyType type, String message) {
    _anomalyController.add(SecurityAnomaly(type, message));
  }

  SecurityService(this._storage, this._deviceInfo);

  /// Check if the device is secure (not rooted/jailbroken)
  Future<bool> isDeviceSecure() async {
    try {
      bool isJailBroken = await SafeDevice.isJailBroken;
      // In production, we would also check isRealDevice.
      // For now, we allow emulators but block jailbroken devices.
      return !isJailBroken;
    } catch (e) {
      // Fallback: if check fails, assume insecure for safety
      return false;
    }
  }

  /// Capture Hardware ID and return a salted hash
  Future<String> getDeviceBindingHash() async {
    final rawId = await _deviceInfo.getDeviceId();
    const salt = "BOOK_MY_EVENT_PK_SALT_2026";
    final bytes = utf8.encode(rawId + salt);
    return sha256.convert(bytes).toString();
  }

  /// Generate a 32-byte Nonce
  String generateNonce() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// Derive Session Key: SHA-256(Master_Secret + A-nonce + S-nonce)
  Future<void> deriveAndStoreSessionKey(
      String masterSecret, String aNonce, String sNonce,
      {String? region}) async {
    final input = masterSecret + aNonce + sNonce;
    final bytes = utf8.encode(input);
    final key = sha256.convert(bytes).toString();
    await _storage.write(key: _sessionKeyKey, value: key);
    if (region != null) {
      await _storage.write(key: _sessionRegionKey, value: region);
    }
  }

  /// Get stored Session Key
  Future<String?> getSessionKey() async {
    return await _storage.read(key: _sessionKeyKey);
  }

  /// Get stored Session Region
  Future<String?> getSessionRegion() async {
    return await _storage.read(key: _sessionRegionKey);
  }

  /// Clear session data (on drift, hijack or logout)
  Future<void> clearSession() async {
    await _storage.delete(key: _sessionKeyKey);
    await _storage.delete(key: _sessionRegionKey);
    await _storage.delete(key: _sessionBindingKey);
  }

  /// Store Session Binding Context: Hash(DeviceID + IPClass + OS)
  Future<void> storeSessionBinding(String ipClass) async {
    final deviceHash = await getDeviceBindingHash();
    final bindingInfo = "$deviceHash|$ipClass";
    final bindingHash = sha256.convert(utf8.encode(bindingInfo)).toString();
    await _storage.write(key: _sessionBindingKey, value: bindingHash);
  }

  /// Verify Session Binding: Returns false if Hijacking is suspected
  Future<bool> verifySessionBinding(String currentIpClass) async {
    final storedBinding = await _storage.read(key: _sessionBindingKey);
    if (storedBinding == null) return true; // No binding enforced yet

    final deviceHash = await getDeviceBindingHash();
    final currentBindingInfo = "$deviceHash|$currentIpClass";
    final currentBindingHash =
        sha256.convert(utf8.encode(currentBindingInfo)).toString();

    return storedBinding == currentBindingHash;
  }

  /// Generate MIC (Message Integrity Code)
  String generateMIC(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final hmac = Hmac(sha256, keyBytes);
    return hmac.convert(dataBytes).toString();
  }

  /// Generate Request Signature: HMAC-SHA256(Method + Path + Timestamp + DeviceID + PayloadHash)
  Future<String?> signRequest({
    required String method,
    required String path,
    required String timestamp,
    required String deviceId,
    required String payload,
  }) async {
    final sessionKey = await getSessionKey();
    if (sessionKey == null) return null;

    final payloadHash = sha256.convert(utf8.encode(payload)).toString();
    final dataToSign = "$method|$path|$timestamp|$deviceId|$payloadHash";

    final keyBytes = utf8.encode(sessionKey);
    final dataBytes = utf8.encode(dataToSign);
    final hmac = Hmac(sha256, keyBytes);

    return hmac.convert(dataBytes).toString();
  }

  /// Store Master Secret (derived after initial login)
  Future<void> storeMasterSecret(String secret) async {
    await _storage.write(key: _masterSecretKey, value: secret);
  }

  Future<String?> getMasterSecret() async {
    return await _storage.read(key: _masterSecretKey);
  }
}
