// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wedding_app/main.dart';
import 'package:wedding_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wedding_app/features/auth/domain/entities/user_entity.dart';
import 'package:wedding_app/core/security/behavioral_analytics_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:wedding_app/core/network/services/device_info_service.dart';
import 'package:wedding_app/core/security/security_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<void> logout() async {}

  @override
  Future<String> sendOtp(String phoneNumber) async => "123456";

  @override
  Future<bool> validatePhoneNumber(
          String phoneNumber, String countryCode) async =>
      true;

  @override
  Future<UserEntity> verifyOtp(String phoneNumber, String otp) async {
    return UserEntity(id: '1', phoneNumber: phoneNumber);
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App should load', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final mockAuthRepository = MockAuthRepository();
      final mockBehavioralService = BehavioralAnalyticsService();

      // We can use the real service with mocked storage if needed, but for a load test,
      // a basic instantiation works as long as we don't call real platform code.
      final mockSecurityService =
          SecurityService(const FlutterSecureStorage(), DeviceInfoService());

      // Build our app and trigger a frame.
      await tester.pumpWidget(WeddingOSApp(
        authRepository: mockAuthRepository,
        behavioralService: mockBehavioralService,
        securityService: mockSecurityService,
      ));

      // Verify that the app starts
      expect(find.byType(MaterialApp), findsOneWidget);

      // Dispose to avoid stream leaks
      mockBehavioralService.dispose();
    });
  });
}
