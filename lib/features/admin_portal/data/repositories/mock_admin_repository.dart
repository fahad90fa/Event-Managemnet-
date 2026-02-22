import '../../domain/entities/admin_models.dart';
import '../../domain/repositories/admin_repository.dart';

class MockAdminRepository implements AdminRepository {
  final List<AdminUser> _users = [
    AdminUser(
        id: '1',
        name: 'Jamshed Khan',
        phone: '+923001234567',
        status: UserStatus.active,
        role: 'Client',
        lastActive: DateTime.now().subtract(const Duration(minutes: 5))),
    AdminUser(
        id: '2',
        name: 'Sara Ahmed',
        phone: '+923119876543',
        status: UserStatus.active,
        role: 'Client',
        lastActive: DateTime.now().subtract(const Duration(hours: 2))),
    AdminUser(
        id: '3',
        name: 'Bilal Malik',
        phone: '+923225556666',
        status: UserStatus.blocked,
        role: 'Client',
        lastActive: DateTime.now().subtract(const Duration(days: 3))),
    AdminUser(
        id: '4',
        name: 'Zoya Qureshi',
        phone: '+923334448888',
        status: UserStatus.pending,
        role: 'Vendor-Admin',
        lastActive: DateTime.now().subtract(const Duration(minutes: 45))),
  ];

  final List<AdminVendor> _vendors = [
    const AdminVendor(
        id: 'V1',
        businessName: 'Royal Gardens',
        category: 'Venues',
        status: VendorStatus.verified,
        rating: 4.8,
        totalBookings: 156,
        revenue: 450000),
    const AdminVendor(
        id: 'V2',
        businessName: 'SnapShot Studio',
        category: 'Photography',
        status: VendorStatus.verified,
        rating: 4.5,
        totalBookings: 89,
        revenue: 120000),
    const AdminVendor(
        id: 'V3',
        businessName: 'Taste of Lahore',
        category: 'Catering',
        status: VendorStatus.pendingApproval,
        rating: 0,
        totalBookings: 0,
        revenue: 0),
    const AdminVendor(
        id: 'V4',
        businessName: 'Elite Decor',
        category: 'Decoration',
        status: VendorStatus.suspended,
        rating: 3.2,
        totalBookings: 45,
        revenue: 65000),
  ];

  final List<AdminBooking> _bookings = [
    AdminBooking(
        id: 'B1',
        userName: 'Jamshed Khan',
        vendorName: 'Royal Gardens',
        amount: 50000,
        status: BookingStatus.confirmed,
        date: DateTime.now().add(const Duration(days: 45))),
    AdminBooking(
        id: 'B2',
        userName: 'Sara Ahmed',
        vendorName: 'SnapShot Studio',
        amount: 15000,
        status: BookingStatus.pending,
        date: DateTime.now().add(const Duration(days: 12))),
    AdminBooking(
        id: 'B3',
        userName: 'Aslam Pervaiz',
        vendorName: 'Taste of Lahore',
        amount: 35000,
        status: BookingStatus.completed,
        date: DateTime.now().subtract(const Duration(days: 2))),
  ];

  final List<AdminFinanceEntry> _financeEntries = [
    AdminFinanceEntry(
        id: 'F1',
        type: 'Platform Fee',
        amount: 5000,
        date: DateTime.now().subtract(const Duration(hours: 4)),
        entityName: 'Royal Gardens'),
    AdminFinanceEntry(
        id: 'F2',
        type: 'Payout',
        amount: 28000,
        date: DateTime.now().subtract(const Duration(days: 1)),
        entityName: 'SnapShot Studio'),
    AdminFinanceEntry(
        id: 'F3',
        type: 'Refund',
        amount: 12000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        entityName: 'Sara Ahmed'),
  ];

  final List<AdminDispute> _disputes = [
    AdminDispute(
        id: 'D1',
        bookingId: 'B2',
        reason: 'Service not as described',
        status: DisputeStatus.open,
        openedAt: DateTime.now().subtract(const Duration(days: 1))),
    AdminDispute(
        id: 'D2',
        bookingId: 'B1',
        reason: 'Cancellation fee dispute',
        status: DisputeStatus.resolved,
        openedAt: DateTime.now().subtract(const Duration(days: 5))),
  ];

  final List<AdminDevice> _devices = [
    AdminDevice(
        id: 'DV1',
        deviceName: 'iPhone 15 Pro',
        model: 'A2848',
        osVersion: 'iOS 17.2',
        appVersion: 'v1.4.2',
        lastActive: DateTime.now().subtract(const Duration(minutes: 2)),
        ipAddress: '192.168.10.45',
        status: DeviceTrustStatus.trusted,
        isRooted: false,
        batteryLevel: '88%',
        storageFree: '24GB'),
    AdminDevice(
        id: 'DV2',
        deviceName: 'Pixel 8',
        model: 'GPJ41',
        osVersion: 'Android 14',
        appVersion: 'v1.4.1',
        lastActive: DateTime.now().subtract(const Duration(hours: 4)),
        ipAddress: '182.160.4.12',
        status: DeviceTrustStatus.flagged,
        isRooted: true,
        batteryLevel: '42%',
        storageFree: '128MB'),
    AdminDevice(
        id: 'DV3',
        deviceName: 'Samsung S23',
        model: 'SM-S911B',
        osVersion: 'Android 13',
        appVersion: 'v1.4.2',
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
        ipAddress: '110.39.42.188',
        status: DeviceTrustStatus.trusted,
        isRooted: false,
        batteryLevel: '15%',
        storageFree: '12GB'),
  ];

  final List<DevicePermissionCompliance> _permissionCompliance = [
    const DevicePermissionCompliance(deviceId: 'DV1', status: {
      PermissionCategory.camera: PermissionLevel.granted,
      PermissionCategory.location: PermissionLevel.risky,
      PermissionCategory.contacts: PermissionLevel.granted,
      PermissionCategory.storage: PermissionLevel.granted,
      PermissionCategory.microphone: PermissionLevel.denied,
    }),
    const DevicePermissionCompliance(deviceId: 'DV2', status: {
      PermissionCategory.camera: PermissionLevel.granted,
      PermissionCategory.location: PermissionLevel.granted,
      PermissionCategory.contacts: PermissionLevel.granted,
      PermissionCategory.storage: PermissionLevel.risky,
      PermissionCategory.microphone: PermissionLevel.granted,
    }),
  ];

  final List<IPMetric> _ipMetrics = [
    const IPMetric(ipClass: 'Class C', isp: 'Nayatel', activeNodes: 1240),
    const IPMetric(ipClass: 'Class B', isp: 'PTCL', activeNodes: 4500),
    const IPMetric(ipClass: 'Class A', isp: 'Jazz', activeNodes: 8900),
    const IPMetric(
        ipClass: 'Class C', isp: 'ProxyExit', activeNodes: 12, isBlocked: true),
  ];

  @override
  Future<List<AdminUser>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users;
  }

  @override
  Future<List<AdminVendor>> getVendors() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _vendors;
  }

  @override
  Future<List<AdminBooking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings;
  }

  @override
  Future<List<AdminFinanceEntry>> getFinanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _financeEntries;
  }

  @override
  Future<List<AdminDispute>> getDisputes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _disputes;
  }

  @override
  Future<List<AdminDevice>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _devices;
  }

  @override
  Future<List<DevicePermissionCompliance>> getPermissionCompliance() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _permissionCompliance;
  }

  @override
  Future<List<IPMetric>> getIPMetrics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _ipMetrics;
  }

  @override
  Future<void> updateUserStatus(String userId, UserStatus status) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = AdminUser(
        id: _users[index].id,
        name: _users[index].name,
        phone: _users[index].phone,
        status: status,
        role: _users[index].role,
        lastActive: _users[index].lastActive,
      );
    }
  }

  @override
  Future<void> updateVendorStatus(String vendorId, VendorStatus status) async {
    final index = _vendors.indexWhere((v) => v.id == vendorId);
    if (index != -1) {
      _vendors[index] = AdminVendor(
        id: _vendors[index].id,
        businessName: _vendors[index].businessName,
        category: _vendors[index].category,
        status: status,
        rating: _vendors[index].rating,
        totalBookings: _vendors[index].totalBookings,
        revenue: _vendors[index].revenue,
      );
    }
  }
}
