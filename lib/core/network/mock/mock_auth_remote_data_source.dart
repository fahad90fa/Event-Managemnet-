import 'dart:developer';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import '../../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../security/ip_management_service.dart';

/// Mock implementation of AuthRemoteDataSource for development
/// This allows testing the app without a real backend
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  // Store generated OTPs in memory for mock validation
  static final Map<String, String> _generatedOtps = {};
  final IpManagementService _ipManager = IpManagementService();

  @override
  Future<bool> validatePhone(String phoneNumber, String countryCode) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Accept any Pakistani phone number (starts with 03 and has 11 digits)
    if (countryCode == 'PK' &&
        phoneNumber.startsWith('03') &&
        phoneNumber.length == 11) {
      return true;
    }

    // For other countries, just check if it has at least 10 digits
    return phoneNumber.length >= 10;
  }

  @override
  Future<String> sendOtp(
      String phoneNumber, Map<String, dynamic> deviceInfo) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Admin Backdoor - Always use the same code
    if (phoneNumber == "03000047478") {
      _generatedOtps[phoneNumber] = "156200";
    } else {
      // Generate a random 6-digit OTP
      final randomOtp = (100000 + math.Random().nextInt(900000)).toString();
      _generatedOtps[phoneNumber] = randomOtp;
    }

    log('📱 [MOCK] OTP sent to $phoneNumber: ${_generatedOtps[phoneNumber]}');
    return _generatedOtps[phoneNumber]!;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otpCode,
      Map<String, dynamic> deviceInfo) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Admin Backdoor
    if (phoneNumber == "03000047478") {
      if (otpCode != "156200") {
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/verify-otp'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/verify-otp'),
            statusCode: 401,
            data: {
              'success': false,
              'error': {
                'code': 'INVALID_OTP',
                'message': 'Invalid administrative secure code.',
              }
            },
          ),
        );
      }
    }

    // Verify against stored OTP
    final storedOtp = _generatedOtps[phoneNumber];

    if (otpCode == storedOtp) {
      log('✅ [MOCK] OTP verified for $phoneNumber');

      // Clear OTP after success
      _generatedOtps.remove(phoneNumber);

      // Return mock user data with tokens
      return {
        'access_token':
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token':
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 'mock_user_${phoneNumber.hashCode}',
          'phone_number': phoneNumber,
          'name': 'Test User',
          'created_at': DateTime.now().toIso8601String(),
        }
      };
    }

    // Invalid OTP
    throw DioException(
      requestOptions: RequestOptions(path: '/auth/verify-otp'),
      response: Response(
        requestOptions: RequestOptions(path: '/auth/verify-otp'),
        statusCode: 400,
        data: {
          'success': false,
          'error': {
            'code': 'INVALID_OTP',
            'message': 'The OTP code is invalid or expired',
          }
        },
      ),
    );
  }

  @override
  Future<String> refreshToken(String refreshToken, String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    log('🔄 [MOCK] Token refreshed');

    // Return a new mock access token
    return 'mock_access_token_refreshed_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<Map<String, dynamic>> initSecurityHandshake(
      String aNonce, String deviceBindingHash) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulate Backend IP Classification, Geo-Fencing & Redundancy
    const mockClientIp = "182.45.1.20"; // Class B PK
    final netContext = _ipManager.classifyIp(mockClientIp);

    // Simulate Region Health (Mocking pkSouth as DOWN for demonstration)
    final isPrimaryRegionHealthy = netContext.region != ServiceRegion.pkSouth;
    final targetRegion = _ipManager.getTargetRegion(netContext,
        isPrimaryHealthy: isPrimaryRegionHealthy);

    log('🛡️ [BACKEND-REDUNDANCY] Region Check: ${netContext.region.name} (Health: $isPrimaryRegionHealthy)');
    if (!isPrimaryRegionHealthy) {
      log('🔄 [FAILOVER] rerouting traffic from ${netContext.region.name} to REDUNDANT NODE: ${targetRegion.name}');
    }

    if (netContext.type == NetworkType.bogon || netContext.isGeoBlocked) {
      final errorPrefix =
          netContext.isGeoBlocked ? "GEO_FENCE_VIOLATION" : "TRAFFIC_REJECTED";
      throw DioException(
        requestOptions: RequestOptions(path: 'auth/handshake'),
        response: Response(
          requestOptions: RequestOptions(path: 'auth/handshake'),
          statusCode: 403,
          data: {
            'error':
                '$errorPrefix: IP ${netContext.ip} from ${netContext.country} is not allowed.'
          },
        ),
      );
    }

    log('🔐 [MOCK-IDS] Handshake INIT received. Device Hash: $deviceBindingHash');
    return {
      's_nonce': 'mock_server_nonce_${DateTime.now().millisecond}',
      'server_mic': 'mock_server_mic_verified',
      'network_tier': netContext.networkClass.name,
      'serving_node': targetRegion.name,
      'redundancy_status': isPrimaryRegionHealthy ? 'ACTIVE' : 'FAILOVER',
    };
  }

  @override
  Future<Map<String, dynamic>> confirmSecurityHandshake(
      String clientMic) async {
    await Future.delayed(const Duration(milliseconds: 400));
    log('🔐 [MOCK-IDS] Handshake CONFIRM received. MIC: $clientMic');
    return {
      'status': 'SUCCESS',
      'session_token':
          'secure_session_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  @override
  Future<Map<String, dynamic>> getProtectedData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate Drift: 10% chance of detecting a stale session due to regional sync latency
    final hasDrift = math.Random().nextInt(100) < 10;

    if (hasDrift) {
      log('⚠️ [MOCK-BACKEND] DRIFT_DETECTED: Session key not found in pk_north (stale regional sync).');
      throw DioException(
        requestOptions: RequestOptions(path: 'auth/protected-data'),
        response: Response(
          requestOptions: RequestOptions(path: 'auth/protected-data'),
          statusCode: 412, // Precondition Failed
          data: {
            'error': 'DRIFT_DETECTED: Session state out of sync across regions.'
          },
        ),
      );
    }

    // Simulate Hijacking: 5% chance of detecting a concurrent session on a different fingerprint
    final hasHijack = math.Random().nextInt(100) < 5;
    if (hasHijack) {
      log('🚨 [MOCK-BACKEND] SESSION_HIJACK_DETECTED: Access token used from unauthorized device fingerprint.');
      throw DioException(
        requestOptions: RequestOptions(path: 'auth/protected-data'),
        response: Response(
          requestOptions: RequestOptions(path: 'auth/protected-data'),
          statusCode: 401,
          data: {'error': 'HIJACK_DETECTED: Session compromised.'},
        ),
      );
    }

    return {
      'data': 'TOP_SECRET_WEDDING_PLAN',
      'serving_node': 'pk_north',
    };
  }
}
