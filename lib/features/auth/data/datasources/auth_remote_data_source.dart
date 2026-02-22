import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<bool> validatePhone(String phoneNumber, String countryCode);
  Future<String> sendOtp(String phoneNumber, Map<String, dynamic> deviceInfo);
  Future<Map<String, dynamic>> verifyOtp(
      String phoneNumber, String otpCode, Map<String, dynamic> deviceInfo);
  Future<String> refreshToken(String refreshToken, String deviceId);

  // Security Handshake
  Future<Map<String, dynamic>> initSecurityHandshake(
      String aNonce, String deviceBindingHash);
  Future<Map<String, dynamic>> confirmSecurityHandshake(String clientMic);
  Future<Map<String, dynamic>> getProtectedData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<bool> validatePhone(String phoneNumber, String countryCode) async {
    final response = await _dio.post(
      'auth/validate-phone',
      data: {
        'phone_number': phoneNumber,
        'country_code': countryCode,
      },
    );

    // According to spec: Success (200) returns is_valid
    return response.data['data']['is_valid'] ?? false;
  }

  @override
  Future<String> sendOtp(
      String phoneNumber, Map<String, dynamic> deviceInfo) async {
    final response = await _dio.post(
      'auth/send-otp',
      data: {
        'phone_number': phoneNumber,
        'device_info': deviceInfo,
      },
    );

    // In prod, this would just be a message, but for development we might return the code
    return response.data['data']['otp_code'] ??
        response.data['data']['message'] ??
        'OTP Sent';
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otpCode,
      Map<String, dynamic> deviceInfo) async {
    final response = await _dio.post(
      'auth/verify-otp',
      data: {
        'phone_number': phoneNumber,
        'otp_code': otpCode,
        'device_info': deviceInfo,
      },
    );

    return response.data['data'];
  }

  @override
  Future<String> refreshToken(String refreshToken, String deviceId) async {
    final response = await _dio.post(
      'auth/refresh-token',
      data: {
        'refresh_token': refreshToken,
        'device_id': deviceId,
      },
    );

    return response.data['data']['access_token'];
  }

  @override
  Future<Map<String, dynamic>> initSecurityHandshake(
      String aNonce, String deviceBindingHash) async {
    final response = await _dio.post(
      'auth/handshake/init',
      data: {
        'a_nonce': aNonce,
        'device_binding_hash': deviceBindingHash,
      },
    );
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> confirmSecurityHandshake(
      String clientMic) async {
    final response = await _dio.post(
      'auth/handshake/confirm',
      data: {
        'client_mic': clientMic,
      },
    );
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>> getProtectedData() async {
    final response = await _dio.get('auth/protected-data');
    return response.data['data'];
  }
}
