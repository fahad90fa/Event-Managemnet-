import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/core/security/ip_management_service.dart';

void main() {
  final ipManager = IpManagementService();

  group('IpManagementService bitwise & geo-fencing tests', () {
    test('Class A detection (Public US)', () {
      final context = ipManager.classifyIp('8.8.8.8');
      expect(context.networkClass, NetworkClass.A);
      expect(context.country, 'US');
      expect(ipManager.getRateLimit(context), 500);
    });

    test('Class B detection (Allowed PK)', () {
      // 182.x is Class B (10110110 in binary, starts with 10)
      final context = ipManager.classifyIp('182.45.1.20');
      expect(context.networkClass, NetworkClass.B);
      expect(context.country, 'PK');
      expect(context.isGeoBlocked, false);
      expect(ipManager.getRateLimit(context), 1000);
    });

    test('Class B detection (Blocked CN)', () {
      // 128.x is CN in our mock
      final context = ipManager.classifyIp('128.0.0.1');
      expect(context.networkClass, NetworkClass.B);
      expect(context.country, 'CN');
      expect(context.isGeoBlocked, true);
      expect(ipManager.getRateLimit(context), 0); // Blocked
    });

    test('Class C Internal Detection', () {
      final context = ipManager.classifyIp('192.168.1.1');
      expect(context.networkClass, NetworkClass.C);
      expect(context.type, NetworkType.internal);
      expect(context.country, 'Internal');
      expect(ipManager.getRateLimit(context), 5000);
    });

    test('Bogon Detection', () {
      final context = ipManager.classifyIp('0.0.0.0');
      expect(context.type, NetworkType.bogon);
      expect(ipManager.getRateLimit(context), 0);
    });
  });
}
