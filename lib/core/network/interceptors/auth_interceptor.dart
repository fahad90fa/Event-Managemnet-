import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/device_info_service.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final DeviceInfoService _deviceInfo;

  AuthInterceptor(this._storage, this._deviceInfo);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Add Device Fingerprint Headers
    final deviceId = await _deviceInfo.getDeviceId();
    options.headers['X-Device-ID'] = deviceId;
    options.headers['X-Platform'] = Platform.isAndroid ? 'android' : 'ios';
    options.headers['X-App-Version'] = '1.0.0';

    // 2. Add Authorization Header
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Attempt to refresh the token
      final refreshToken = await _storage.read(key: 'refresh_token');

      if (refreshToken != null) {
        try {
          // Get device ID for refresh request
          final deviceId = await _deviceInfo.getDeviceId();

          // Create a new Dio instance to avoid interceptor loops
          final dio = Dio();
          final response = await dio.post(
            'https://api.weddingos.com/v1/auth/refresh-token',
            data: {
              'refresh_token': refreshToken,
              'device_id': deviceId,
            },
          );

          // Extract and store the new access token
          final newAccessToken = response.data['data']['access_token'];
          await _storage.write(key: 'access_token', value: newAccessToken);

          // Retry the original request with the new token
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await Dio().fetch(requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          // If refresh fails, clear tokens and pass the error
          await _storage.delete(key: 'access_token');
          await _storage.delete(key: 'refresh_token');
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }
}
