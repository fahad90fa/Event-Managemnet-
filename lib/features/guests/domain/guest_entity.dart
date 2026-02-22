import 'package:equatable/equatable.dart';

enum RSVPStatus { pending, attending, declined, notSent }

enum GuestSide { groom, bride }

class GuestEntity extends Equatable {
  final String id;
  final String name;
  final String relation; // Uncle, Friend, Cousin
  final int familySize;
  final RSVPStatus rsvpStatus;
  final GuestSide side;
  final String? phoneNumber;
  final bool isCheckedIn;
  final DateTime? checkInTime;

  const GuestEntity({
    required this.id,
    required this.name,
    required this.relation,
    required this.familySize,
    required this.rsvpStatus,
    required this.side,
    this.phoneNumber,
    this.isCheckedIn = false,
    this.checkInTime,
  });

  GuestEntity copyWith({
    String? id,
    String? name,
    String? relation,
    int? familySize,
    RSVPStatus? rsvpStatus,
    GuestSide? side,
    String? phoneNumber,
    bool? isCheckedIn,
    DateTime? checkInTime,
  }) {
    return GuestEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      familySize: familySize ?? this.familySize,
      rsvpStatus: rsvpStatus ?? this.rsvpStatus,
      side: side ?? this.side,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        relation,
        familySize,
        rsvpStatus,
        side,
        phoneNumber,
        isCheckedIn,
        checkInTime
      ];
}
