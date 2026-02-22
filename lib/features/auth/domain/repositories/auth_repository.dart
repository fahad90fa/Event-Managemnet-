import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> validatePhoneNumber(String phoneNumber, String countryCode);
  Future<String> sendOtp(String phoneNumber);
  Future<UserEntity> verifyOtp(String phoneNumber, String otp);
  Future<bool> isAuthenticated();
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}
