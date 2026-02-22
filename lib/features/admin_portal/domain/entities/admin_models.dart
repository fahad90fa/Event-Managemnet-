import 'package:equatable/equatable.dart';

enum UserStatus { active, blocked, pending }

enum VendorStatus { verified, unverified, suspended, pendingApproval }

enum BookingStatus { confirmed, pending, cancelled, completed }

enum DisputeStatus { open, resolved, escalated }

enum DeviceTrustStatus { trusted, flagged, banned }

enum PermissionCategory { camera, location, contacts, storage, microphone }

enum PermissionLevel { granted, denied, risky }

class AdminUser extends Equatable {
  final String id;
  final String name;
  final String phone;
  final UserStatus status;
  final String role;
  final DateTime lastActive;

  const AdminUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
    required this.role,
    required this.lastActive,
  });

  @override
  List<Object?> get props => [id, name, phone, status, role, lastActive];
}

class AdminVendor extends Equatable {
  final String id;
  final String businessName;
  final String category;
  final VendorStatus status;
  final double rating;
  final int totalBookings;
  final double revenue;

  const AdminVendor({
    required this.id,
    required this.businessName,
    required this.category,
    required this.status,
    required this.rating,
    required this.totalBookings,
    required this.revenue,
  });

  @override
  List<Object?> get props =>
      [id, businessName, category, status, rating, totalBookings, revenue];
}

class AdminBooking extends Equatable {
  final String id;
  final String userName;
  final String vendorName;
  final double amount;
  final BookingStatus status;
  final DateTime date;

  const AdminBooking({
    required this.id,
    required this.userName,
    required this.vendorName,
    required this.amount,
    required this.status,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userName, vendorName, amount, status, date];
}

class AdminFinanceEntry extends Equatable {
  final String id;
  final String type; // Payout, Platform Fee, Refund
  final double amount;
  final DateTime date;
  final String entityName;

  const AdminFinanceEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.entityName,
  });

  @override
  List<Object?> get props => [id, type, amount, date, entityName];
}

class AdminDispute extends Equatable {
  final String id;
  final String bookingId;
  final String reason;
  final DisputeStatus status;
  final DateTime openedAt;

  const AdminDispute({
    required this.id,
    required this.bookingId,
    required this.reason,
    required this.status,
    required this.openedAt,
  });

  @override
  List<Object?> get props => [id, bookingId, reason, status, openedAt];
}

class AdminDevice extends Equatable {
  final String id;
  final String deviceName;
  final String model;
  final String osVersion;
  final String appVersion;
  final DateTime lastActive;
  final String ipAddress;
  final DeviceTrustStatus status;
  final bool isRooted;
  final String batteryLevel;
  final String storageFree;

  const AdminDevice({
    required this.id,
    required this.deviceName,
    required this.model,
    required this.osVersion,
    required this.appVersion,
    required this.lastActive,
    required this.ipAddress,
    required this.status,
    required this.isRooted,
    required this.batteryLevel,
    required this.storageFree,
  });

  @override
  List<Object?> get props => [
        id,
        deviceName,
        model,
        osVersion,
        appVersion,
        lastActive,
        ipAddress,
        status,
        isRooted,
        batteryLevel,
        storageFree,
      ];
}

class DevicePermissionCompliance extends Equatable {
  final String deviceId;
  final Map<PermissionCategory, PermissionLevel> status;

  const DevicePermissionCompliance({
    required this.deviceId,
    required this.status,
  });

  @override
  List<Object?> get props => [deviceId, status];
}

class IPMetric extends Equatable {
  final String ipClass; // Class A, B, C
  final String isp;
  final int activeNodes;
  final bool isBlocked;

  const IPMetric({
    required this.ipClass,
    required this.isp,
    required this.activeNodes,
    this.isBlocked = false,
  });

  @override
  List<Object?> get props => [ipClass, isp, activeNodes, isBlocked];
}
