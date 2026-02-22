import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/security/behavioral_analytics_service.dart';
import '../../../../core/security/security_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSendOtpRequested extends AuthEvent {
  final String phoneNumber;
  const AuthSendOtpRequested(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String otp;
  const AuthVerifyOtpRequested(this.phoneNumber, this.otp);
  @override
  List<Object> get props => [phoneNumber, otp];
}

class AuthLogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String phoneNumber;
  final String? otp;
  const AuthOtpSent(this.phoneNumber, {this.otp});
  @override
  List<Object?> get props => [phoneNumber, otp];
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}

class AuthUnauthenticated extends AuthState {}

class AuthReverificationRequired extends AuthState {
  final String reason;
  const AuthReverificationRequired(this.reason);
  @override
  List<Object> get props => [reason];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final BehavioralAnalyticsService? _behavioralService;
  final SecurityService? _securityService;
  StreamSubscription? _trustSubscription;
  StreamSubscription? _securitySubscription;

  AuthBloc({
    required AuthRepository authRepository,
    BehavioralAnalyticsService? behavioralService,
    SecurityService? securityService,
  })  : _authRepository = authRepository,
        _behavioralService = behavioralService,
        _securityService = securityService,
        super(AuthInitial()) {
    // Listen for behavioral trust anomalies
    _trustSubscription = _behavioralService?.trustScoreStream.listen((score) {
      if (score < 40 && state is AuthAuthenticated) {
        add(const _AuthTrustAnomalyDetected("Low Behavioral Trust Score"));
      }
    });

    // Listen for infrastructure anomalies (Drift, Hijack)
    _securitySubscription = _securityService?.anomalyStream.listen((anomaly) {
      if (state is AuthAuthenticated) {
        if (anomaly.type == SecurityAnomalyType.drift) {
          add(_AuthTrustAnomalyDetected("Regional Drift: ${anomaly.message}"));
        } else if (anomaly.type == SecurityAnomalyType.hijack) {
          add(AuthLogoutRequested()); // Force logout on hijack
        }
      }
    });

    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSendOtpRequested>(_onSendOtpRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<_AuthTrustAnomalyDetected>(_onTrustAnomalyDetected);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSendOtpRequested(
      AuthSendOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Step 1: Validate Phone (as per spec)
      final isValid =
          await _authRepository.validatePhoneNumber(event.phoneNumber, "PK");
      if (!isValid) {
        emit(const AuthFailure("Please enter a valid mobile number"));
        emit(AuthUnauthenticated());
        return;
      }

      // Step 2: Send OTP
      final otp = await _authRepository.sendOtp(event.phoneNumber);
      emit(AuthOtpSent(event.phoneNumber, otp: otp));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
      AuthVerifyOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepository.verifyOtp(event.phoneNumber, event.otp);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
      // Emit OtpSent again so UI stays on OTP screen, but handle error display separately
      emit(AuthOtpSent(event.phoneNumber));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  void _onTrustAnomalyDetected(
      _AuthTrustAnomalyDetected event, Emitter<AuthState> emit) {
    if (state is AuthAuthenticated) {
      emit(AuthReverificationRequired(event.reason));
    }
  }

  @override
  Future<void> close() {
    _trustSubscription?.cancel();
    _securitySubscription?.cancel();
    return super.close();
  }
}

/// Internal Event
class _AuthTrustAnomalyDetected extends AuthEvent {
  final String reason;
  const _AuthTrustAnomalyDetected(this.reason);
  @override
  List<Object> get props => [reason];
}
