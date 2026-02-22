import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String? displayName;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.displayName,
  });

  @override
  List<Object?> get props => [id, phoneNumber, displayName];
}
