import 'dart:io';

enum NetworkClass { A, B, C, D, E, unknown }

enum NetworkType { public, private, internal, bogon }

enum ServiceRegion { pkSouth, pkNorth, gccWest, euWest, unknown }

class NetworkContext {
  final NetworkClass networkClass;
  final NetworkType type;
  final int riskScore;
  final String ip;
  final String country;
  final ServiceRegion region;
  final bool isGeoBlocked;

  NetworkContext({
    required this.networkClass,
    required this.type,
    required this.riskScore,
    required this.ip,
    required this.country,
    required this.region,
    this.isGeoBlocked = false,
  });

  @override
  String toString() =>
      'NetworkContext(class: ${networkClass.name}, type: ${type.name}, region: ${region.name}, country: $country, blocked: $isGeoBlocked)';
}

class IpManagementService {
  // Trusted countries for the Wedding OS ecosystem
  static const List<String> allowedCountries = ['PK', 'AE', 'SA', 'UK'];

  /// Classifies an IP address and determines Regional Redundancy context
  NetworkContext classifyIp(String ipAddress) {
    try {
      final ip = InternetAddress(ipAddress);
      if (ip.type != InternetAddressType.IPv4) {
        return NetworkContext(
          networkClass: NetworkClass.unknown,
          type: NetworkType.public,
          riskScore: 50,
          ip: ipAddress,
          country: 'Unknown',
          region: ServiceRegion.unknown,
        );
      }

      final bytes = ip.rawAddress;
      final ipInt =
          (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];

      NetworkClass netClass = NetworkClass.unknown;
      NetworkType netType = NetworkType.public;
      int riskScore = 10;
      String country = _lookupGeo(bytes);
      ServiceRegion region = _mapServiceRegion(bytes, country);
      bool isGeoBlocked = false;

      // 1. Determine Class using bitwise checks
      if ((ipInt & 0x80000000) == 0) {
        netClass = NetworkClass.A;
      } else if ((ipInt & 0xC0000000) == 0x80000000) {
        netClass = NetworkClass.B;
      } else if ((ipInt & 0xE0000000) == 0xC0000000) {
        netClass = NetworkClass.C;
      }

      // 2. Identify Type (Private/Local/Internal)
      if (bytes[0] == 10 ||
          (bytes[0] == 172 && (bytes[1] >= 16 && bytes[1] <= 31)) ||
          (bytes[0] == 192 && bytes[1] == 168) ||
          bytes[0] == 127) {
        netType = (bytes[0] == 192 || bytes[0] == 127)
            ? NetworkType.internal
            : NetworkType.private;
        riskScore = 0;
        country = 'Internal';
        region = ServiceRegion.unknown;
      } else if (bytes[0] == 0 || bytes[0] >= 224) {
        netType = NetworkType.bogon;
        riskScore = 100;
        country = 'Bogon';
        region = ServiceRegion.unknown;
      }

      // 3. Geo-Fencing (Only for public Class B)
      if (netType == NetworkType.public && netClass == NetworkClass.B) {
        if (!allowedCountries.contains(country)) {
          isGeoBlocked = true;
          riskScore += 40;
        }
      }

      return NetworkContext(
        networkClass: netClass,
        type: netType,
        riskScore: riskScore,
        ip: ipAddress,
        country: country,
        region: region,
        isGeoBlocked: isGeoBlocked,
      );
    } catch (e) {
      return NetworkContext(
        networkClass: NetworkClass.unknown,
        type: NetworkType.bogon,
        riskScore: 100,
        ip: ipAddress,
        country: 'ERR',
        region: ServiceRegion.unknown,
      );
    }
  }

  String _lookupGeo(List<int> bytes) {
    if (bytes[0] == 39 || bytes[0] == 111 || bytes[0] == 182) return 'PK';
    if (bytes[0] == 2 || bytes[0] == 5) return 'AE';
    if (bytes[0] == 8 || bytes[0] == 1) return 'US';
    if (bytes[0] == 128) return 'CN';
    return 'Unknown';
  }

  ServiceRegion _mapServiceRegion(List<int> bytes, String country) {
    if (country == 'PK') {
      return bytes[1] < 128 ? ServiceRegion.pkSouth : ServiceRegion.pkNorth;
    }
    if (country == 'AE' || country == 'SA') return ServiceRegion.gccWest;
    if (country == 'UK' || country == 'US') return ServiceRegion.euWest;
    return ServiceRegion.unknown;
  }

  ServiceRegion getTargetRegion(NetworkContext context,
      {required bool isPrimaryHealthy}) {
    if (isPrimaryHealthy) return context.region;
    switch (context.region) {
      case ServiceRegion.pkSouth:
        return ServiceRegion.pkNorth;
      case ServiceRegion.pkNorth:
        return ServiceRegion.pkSouth;
      case ServiceRegion.gccWest:
        return ServiceRegion.pkSouth;
      default:
        return ServiceRegion.euWest;
    }
  }

  int getRateLimit(NetworkContext context) {
    if (context.type == NetworkType.internal) return 5000;
    if (context.type == NetworkType.bogon || context.isGeoBlocked) return 0;
    switch (context.networkClass) {
      case NetworkClass.A:
        return 500;
      case NetworkClass.B:
        return 1000;
      case NetworkClass.C:
        return 200;
      default:
        return 100;
    }
  }
}
