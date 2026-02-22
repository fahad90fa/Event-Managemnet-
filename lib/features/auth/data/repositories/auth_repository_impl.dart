import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/network/services/device_info_service.dart';
import '../../../../core/security/security_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;
  final DeviceInfoService _deviceInfo;
  final SecurityService _securityService;

  AuthRepositoryImpl(this._remoteDataSource, this._storage, this._deviceInfo,
      this._securityService);

  @override
  Future<bool> validatePhoneNumber(
      String phoneNumber, String countryCode) async {
    return await _remoteDataSource.validatePhone(phoneNumber, countryCode);
  }

  @override
  Future<String> sendOtp(String phoneNumber) async {
    final deviceInfo = await _deviceInfo.getFullDeviceInfo();
    return await _remoteDataSource.sendOtp(phoneNumber, deviceInfo);
  }

  @override
  Future<UserEntity> verifyOtp(String phoneNumber, String otp) async {
    // 1. Device Integrity Check (Root/Jailbreak)
    if (!await _securityService.isDeviceSecure()) {
      _securityService.reportAnomaly(
          SecurityAnomalyType.insecureDevice, "Root/Jailbreak detected.");
      throw Exception(
          "SECURITY_VIOLATION: Device is compromised (Root/Jailbreak detected). Access denied.");
    }

    final deviceInfo = await _deviceInfo.getFullDeviceInfo();
    final data =
        await _remoteDataSource.verifyOtp(phoneNumber, otp, deviceInfo);

    // Extract tokens
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];
    final userData = data['user'];

    // 2. Perform 4-Way Security Handshake
    final aNonce = _securityService.generateNonce();
    final deviceHash = await _securityService.getDeviceBindingHash();

    // Message 1 & 2
    final handshakeResponse =
        await _remoteDataSource.initSecurityHandshake(aNonce, deviceHash);
    final sNonce = handshakeResponse['s_nonce'];
    final serverMic = handshakeResponse['server_mic'];

    // Message 3 (Verify Server & derive Session Key)
    if (serverMic != "mock_server_mic_verified") {
      throw Exception(
          "SECURITY_FAILURE: Server identity could not be verified.");
    }

    final region = handshakeResponse['serving_node'];
    final networkTier = handshakeResponse['network_tier'] ?? 'C';

    await _securityService.deriveAndStoreSessionKey(accessToken, aNonce, sNonce,
        region: region);
    await _securityService.storeSessionBinding(networkTier);
    final sessionKey = await _securityService.getSessionKey();
    final clientMic =
        _securityService.generateMIC("CLIENT_CONFIRM", sessionKey!);

    // Message 4
    await _remoteDataSource.confirmSecurityHandshake(clientMic);

    // Securely store tokens and login timestamp
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(
        key: 'login_timestamp',
        value: DateTime.now().millisecondsSinceEpoch.toString());

    return UserEntity(
      id: userData['id'],
      phoneNumber: userData['phone_number'],
      displayName: userData['name'] ?? 'Guest',
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'access_token');
    final timestampStr = await _storage.read(key: 'login_timestamp');

    if (token == null || timestampStr == null) return false;

    // Check if token is within 30 days
    final loginTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestampStr));
    final difference = DateTime.now().difference(loginTime).inDays;

    if (difference >= 30) {
      // Session expired
      await logout();
      return false;
    }

    return true;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // In a real app, you might fetch from local DB or a /me endpoint
    // For now, we return a mock user if token exists
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;

    return const UserEntity(
      id: "cached_id",
      phoneNumber: "cached_phone",
      displayName: "Cached User",
    );
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'login_timestamp');
  }
}
