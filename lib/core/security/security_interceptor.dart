import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'security_service.dart';
import 'behavioral_analytics_service.dart';

class SecurityInterceptor extends Interceptor {
  final SecurityService _securityService;
  final BehavioralAnalyticsService _behavioralService;
  final String _deviceId;

  SecurityInterceptor(
      this._securityService, this._behavioralService, this._deviceId);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Root/Jailbreak Check
    final isSecure = await _securityService.isDeviceSecure();
    if (!isSecure) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: "TERMINATED: Insecure environment detected (Root/Jailbreak).",
          type: DioExceptionType.cancel,
        ),
      );
    }

    // Skip handshake/signing for the handshake endpoints themselves to avoid recursion
    if (options.path.contains('/auth/handshake')) {
      return handler.next(options);
    }

    // 2. Ensure Handshake is completed (Session Key exists)
    String? sessionKey = await _securityService.getSessionKey();

    // If we are authenticated but have no session key, we might need a handshake
    // For this implementation, we assume the handshake is triggered after login.

    if (sessionKey != null) {
      // 3. Request Signing & Integrity
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final body = options.data != null ? jsonEncode(options.data) : "";

      final signature = await _securityService.signRequest(
        method: options.method,
        path: options.path,
        timestamp: timestamp,
        deviceId: _deviceId,
        payload: body,
      );

      if (signature != null) {
        options.headers['X-App-Signature'] = signature;
        options.headers['X-Timestamp'] = timestamp;
        options.headers['X-Device-ID'] = _deviceId;

        final sessionRegion = await _securityService.getSessionRegion();
        if (sessionRegion != null) {
          options.headers['X-Session-Region'] = sessionRegion;
        }

        // 4. Behavioral DNA Header
        options.headers['X-Behavioral-Trust-Score'] =
            _behavioralService.getTrustScore().toString();
        options.headers['X-Behavioral-DNA'] =
            _behavioralService.getBehavioralFingerprint();
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If we get a 403 with a specific "SESSION_EXPIRED" or "INVALID_SIGNATURE" error,
    // we could potentially trigger a re-handshake here.
    // 4. Handle Regional Drift (412 Precondition Failed or specific error code)
    if (err.response?.statusCode == 412 ||
        (err.response?.data is Map &&
            err.response?.data['error']?.contains('DRIFT'))) {
      // Clear stale session
      await _securityService.clearSession();
      _securityService.reportAnomaly(
          SecurityAnomalyType.drift, "Regional drift detected.");

      // Usually, we would trigger a re-handshake here.
      // For now, we reject with a specific message.
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error:
              "RE-HANDSHAKE_REQUIRED: Regional drift detected. Internal state synced.",
          type: DioExceptionType.cancel,
        ),
      );
    }

    // 5. Handle Session Hijacking Detection
    if (err.response?.statusCode == 401 &&
        (err.response?.data is Map &&
            err.response?.data['error']?.contains('HIJACK'))) {
      log('🚨 [SECURITY_CRITICAL] SESSION HIJACK ATTEMPT DETECTED. Revoking local credentials.');

      // Wipe everything immediately
      await _securityService.clearSession();
      _securityService.reportAnomaly(SecurityAnomalyType.hijack,
          "Unauthorized device fingerprint detected.");

      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error:
              "TERMINATED: Session hijacked or compromised. Security lockdown initiated.",
          type: DioExceptionType.cancel,
        ),
      );
    }

    if (err.response?.statusCode == 403) {
      // General security violation
    }
    return handler.next(err);
  }
}
