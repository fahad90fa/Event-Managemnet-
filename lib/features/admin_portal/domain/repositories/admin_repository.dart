import '../entities/admin_models.dart';

abstract class AdminRepository {
  Future<List<AdminUser>> getUsers();
  Future<List<AdminVendor>> getVendors();
  Future<List<AdminBooking>> getBookings();
  Future<List<AdminFinanceEntry>> getFinanceHistory();
  Future<List<AdminDispute>> getDisputes();
  Future<List<AdminDevice>> getDevices();
  Future<List<DevicePermissionCompliance>> getPermissionCompliance();
  Future<List<IPMetric>> getIPMetrics();
  Future<void> updateUserStatus(String userId, UserStatus status);
  Future<void> updateVendorStatus(String vendorId, VendorStatus status);
}
