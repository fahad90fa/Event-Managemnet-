import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'services/device_info_service.dart';
import '../security/behavioral_analytics_service.dart';
import '../security/security_service.dart';
import '../security/security_interceptor.dart';

class ApiClient {
  static const String baseUrl =
      'https://api.weddingos.com'; // Replace with your backend URL

  late final Dio _dio;
  final FlutterSecureStorage _storage;
  final DeviceInfoService _deviceInfo;
  final SecurityService _securityService;
  final BehavioralAnalyticsService _behavioralService;

  ApiClient(this._storage, this._deviceInfo, this._securityService,
      this._behavioralService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor(_storage, _deviceInfo));

    // Add Security Layers
    _deviceInfo.getDeviceId().then((deviceId) {
      _dio.interceptors.add(
          SecurityInterceptor(_securityService, _behavioralService, deviceId));
    });

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Dio get dio => _dio;

  // Search
  Future<List<dynamic>> searchBusinesses({
    required String query,
    Map<String, dynamic>? filters,
  }) async {
    final response = await _dio.post('/search', data: {
      'query': query,
      'filters': filters,
    });
    return response.data['results'];
  }

  // Bookings
  Future<List<dynamic>> getBookings() async {
    final response = await _dio.get('/bookings');
    return response.data['bookings'];
  }

  Future<void> cancelBooking(String bookingId) async {
    await _dio.post('/bookings/$bookingId/cancel');
  }

  // Bookmarks
  Future<void> toggleBookmark(String businessId) async {
    await _dio.post('/bookmarks/toggle', data: {
      'businessId': businessId,
    });
  }

  // Messages
  Future<List<dynamic>> getConversations() async {
    final response = await _dio.get('/conversations');
    return response.data['conversations'];
  }

  // Notifications
  Future<List<dynamic>> getNotifications() async {
    final response = await _dio.get('/notifications');
    return response.data['notifications'];
  }

  Future<void> markAllNotificationsRead() async {
    await _dio.post('/notifications/mark-all-read');
  }

  // User Preferences
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    await _dio.post('/users/preferences', data: preferences);
  }
}
