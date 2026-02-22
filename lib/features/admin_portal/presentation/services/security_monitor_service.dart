enum SecurityLevel { safe, warning, critical }

class SecurityEvent {
  final String id;
  final String type;
  final String message;
  final DateTime timestamp;
  final SecurityLevel level;
  final String? ipAddress;

  SecurityEvent({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    required this.level,
    this.ipAddress,
  });
}

class SecurityMonitorService {
  static final List<SecurityEvent> _logs = [
    SecurityEvent(
      id: '1',
      type: 'VELOCITY_ALERT',
      message: 'Suspicious request frequency from IP 192.168.1.45',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      level: SecurityLevel.warning,
      ipAddress: '192.168.1.45',
    ),
    SecurityEvent(
      id: '2',
      type: 'HANDSHAKE_INIT',
      message: 'Secure 4-Way Handshake established for Session 0xAE45',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      level: SecurityLevel.safe,
    ),
    SecurityEvent(
      id: '3',
      type: 'SQL_INJECTION_BLOCK',
      message: 'IDS Blocked: Malicious pattern detected in /api/vendors/search',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      level: SecurityLevel.critical,
      ipAddress: '45.12.33.1',
    ),
    SecurityEvent(
      id: '4',
      type: 'NET_CLASS_A_CLASSIFIED',
      message:
          'Network Class A Detected from US. Applying Strict Rate limit (500 req/min).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      level: SecurityLevel.safe,
      ipAddress: '8.8.8.8',
    ),
    SecurityEvent(
      id: '5',
      type: 'GEO_FENCE_BLOCK',
      message:
          'IDS Termination: Rejected untrusted Class B IP from China (CN).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      level: SecurityLevel.critical,
      ipAddress: '128.0.0.1',
    ),
    SecurityEvent(
      id: '6',
      type: 'TRUSTED_PK_SESSION',
      message: 'Secure Session starting from Pakistan (PK). High QoS assigned.',
      timestamp: DateTime.now().subtract(const Duration(seconds: 15)),
      level: SecurityLevel.safe,
      ipAddress: '39.45.1.20',
    ),
    SecurityEvent(
      id: '7',
      type: 'INTERNAL_ADMIN_ACCESS',
      message:
          'Local Admin Access granted via Class C Internal Network (192.168.x.x).',
      timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
      level: SecurityLevel.safe,
      ipAddress: '192.168.1.100',
    ),
    SecurityEvent(
      id: '8',
      type: 'GEO_REDUNDANCY_FAILOVER',
      message:
          'PRIMARY_SOUTH (pkSouth) unhealthy. Rerouting session to PRIMARY_NORTH (pkNorth).',
      timestamp: DateTime.now().subtract(const Duration(seconds: 10)),
      level: SecurityLevel.warning,
      ipAddress: '182.45.1.20',
    ),
    SecurityEvent(
      id: '9',
      type: 'REGIONAL_HEALTH_SYNC',
      message: 'Service Mesh Health: PK (Stable), GCC (Stable), EU (Syncing).',
      timestamp: DateTime.now(),
      level: SecurityLevel.safe,
    ),
    SecurityEvent(
      id: '10',
      type: 'SESSION_KEY_DRIFT',
      message:
          'IDS Alert: Detected key drift for Session 0xAE45 in GCC Region. Redundancy Sync Lag: 140ms.',
      timestamp: DateTime.now().subtract(const Duration(seconds: 5)),
      level: SecurityLevel.warning,
      ipAddress: '182.45.1.20',
    ),
    SecurityEvent(
      id: '11',
      type: 'DRIFT_RESOLUTION',
      message:
          'State Machine: Clearing stale regional keys. Enforcing re-handshake for data integrity.',
      timestamp: DateTime.now().subtract(const Duration(seconds: 2)),
      level: SecurityLevel.safe,
    ),
    SecurityEvent(
      id: '12',
      type: 'SESSION_HIJACK_BLOCK',
      message:
          'CRITICAL: Blocked unauthorized token use from non-bound hardware fingerprint.',
      timestamp: DateTime.now().subtract(const Duration(seconds: 1)),
      level: SecurityLevel.critical,
      ipAddress: '45.78.22.1',
    ),
    SecurityEvent(
      id: '13',
      type: 'BEHAVIORAL_MATCH',
      message:
          'Trust Logic: Interaction DNA matches historical profile. Session Trust: 100%.',
      timestamp: DateTime.now().subtract(const Duration(milliseconds: 500)),
      level: SecurityLevel.safe,
    ),
  ];

  static List<SecurityEvent> getRecentLogs() => _logs;
}
