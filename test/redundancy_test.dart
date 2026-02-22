import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_app/core/security/ip_management_service.dart';

void main() {
  final ipManager = IpManagementService();

  group('IpManagementService Redundancy & Failover tests', () {
    test('Region Mapping (PK South)', () {
      // 182.45.* -> bytes[1]=45 (< 128) -> South
      final context = ipManager.classifyIp('182.45.1.20');
      expect(context.region, ServiceRegion.pkSouth);
      expect(context.country, 'PK');
    });

    test('Region Mapping (PK North)', () {
      // 182.160.* -> bytes[1]=160 (> 128) -> North
      final context = ipManager.classifyIp('182.160.1.20');
      expect(context.region, ServiceRegion.pkNorth);
    });

    test('Failover Logic: PK South -> PK North', () {
      final context = ipManager.classifyIp('182.45.1.20');
      // Scenario: Primary South is down
      final target =
          ipManager.getTargetRegion(context, isPrimaryHealthy: false);
      expect(target, ServiceRegion.pkNorth);
    });

    test('Failover Logic: GCC -> PK South', () {
      final context = ipManager.classifyIp('2.50.1.1'); // AE (GCC)
      expect(context.region, ServiceRegion.gccWest);
      // Scenario: GCC gateway is down
      final target =
          ipManager.getTargetRegion(context, isPrimaryHealthy: false);
      expect(target, ServiceRegion.pkSouth);
    });

    test('Healthy State: No Reroute', () {
      final context = ipManager.classifyIp('182.45.1.20');
      final target = ipManager.getTargetRegion(context, isPrimaryHealthy: true);
      expect(target, context.region);
    });
  });
}
