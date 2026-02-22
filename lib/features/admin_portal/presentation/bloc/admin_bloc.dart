import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_models.dart';
import '../../domain/repositories/admin_repository.dart';

// Events
abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object?> get props => [];
}

class LoadAdminData extends AdminEvent {}

class UpdateUserStatusEvent extends AdminEvent {
  final String userId;
  final UserStatus status;
  const UpdateUserStatusEvent(this.userId, this.status);
  @override
  List<Object?> get props => [userId, status];
}

class UpdateVendorStatusEvent extends AdminEvent {
  final String vendorId;
  final VendorStatus status;
  const UpdateVendorStatusEvent(this.vendorId, this.status);
  @override
  List<Object?> get props => [vendorId, status];
}

// State
class AdminState extends Equatable {
  final bool isLoading;
  final List<AdminUser> users;
  final List<AdminVendor> vendors;
  final List<AdminBooking> bookings;
  final List<AdminFinanceEntry> financeHistory;
  final List<AdminDispute> disputes;
  final List<AdminDevice> devices;
  final List<DevicePermissionCompliance> permissionCompliance;
  final List<IPMetric> ipMetrics;
  final String? error;

  const AdminState({
    this.isLoading = false,
    this.users = const [],
    this.vendors = const [],
    this.bookings = const [],
    this.financeHistory = const [],
    this.disputes = const [],
    this.devices = const [],
    this.permissionCompliance = const [],
    this.ipMetrics = const [],
    this.error,
  });

  AdminState copyWith({
    bool? isLoading,
    List<AdminUser>? users,
    List<AdminVendor>? vendors,
    List<AdminBooking>? bookings,
    List<AdminFinanceEntry>? financeHistory,
    List<AdminDispute>? disputes,
    List<AdminDevice>? devices,
    List<DevicePermissionCompliance>? permissionCompliance,
    List<IPMetric>? ipMetrics,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      vendors: vendors ?? this.vendors,
      bookings: bookings ?? this.bookings,
      financeHistory: financeHistory ?? this.financeHistory,
      disputes: disputes ?? this.disputes,
      devices: devices ?? this.devices,
      permissionCompliance: permissionCompliance ?? this.permissionCompliance,
      ipMetrics: ipMetrics ?? this.ipMetrics,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        users,
        vendors,
        bookings,
        financeHistory,
        disputes,
        devices,
        permissionCompliance,
        ipMetrics,
        error
      ];
}

// Bloc
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _repository;

  AdminBloc(this._repository) : super(const AdminState()) {
    on<LoadAdminData>(_onLoadAdminData);
    on<UpdateUserStatusEvent>(_onUpdateUserStatus);
    on<UpdateVendorStatusEvent>(_onUpdateVendorStatus);
  }

  Future<void> _onLoadAdminData(
      LoadAdminData event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        _repository.getUsers(),
        _repository.getVendors(),
        _repository.getBookings(),
        _repository.getFinanceHistory(),
        _repository.getDisputes(),
        _repository.getDevices(),
        _repository.getPermissionCompliance(),
        _repository.getIPMetrics(),
      ]);
      emit(state.copyWith(
        isLoading: false,
        users: results[0] as List<AdminUser>,
        vendors: results[1] as List<AdminVendor>,
        bookings: results[2] as List<AdminBooking>,
        financeHistory: results[3] as List<AdminFinanceEntry>,
        disputes: results[4] as List<AdminDispute>,
        devices: results[5] as List<AdminDevice>,
        permissionCompliance: results[6] as List<DevicePermissionCompliance>,
        ipMetrics: results[7] as List<IPMetric>,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateUserStatus(
      UpdateUserStatusEvent event, Emitter<AdminState> emit) async {
    await _repository.updateUserStatus(event.userId, event.status);
    add(LoadAdminData());
  }

  Future<void> _onUpdateVendorStatus(
      UpdateVendorStatusEvent event, Emitter<AdminState> emit) async {
    await _repository.updateVendorStatus(event.vendorId, event.status);
    add(LoadAdminData());
  }
}
