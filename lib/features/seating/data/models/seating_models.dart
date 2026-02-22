import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/seating_entities.dart';

part 'seating_models.g.dart';

@JsonSerializable()
class SeatingLayoutModel extends SeatingLayout {
  const SeatingLayoutModel({
    required super.id,
    required super.eventId,
    required super.layoutName,
    required super.layoutType,
    required super.totalCapacity,
    required super.roomDimensions,
    super.canvasData,
    super.isActive,
  });

  factory SeatingLayoutModel.fromJson(Map<String, dynamic> json) =>
      _$SeatingLayoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeatingLayoutModelToJson(this);
}

@JsonSerializable()
class SeatingSectionModel extends SeatingSection {
  const SeatingSectionModel({
    required super.id,
    required super.seatingLayoutId,
    required super.sectionName,
    required super.sectionType,
    required super.colorCode,
    required super.positionCoordinates,
    required super.capacity,
    super.specialAmenities,
    super.sortOrder,
  });

  factory SeatingSectionModel.fromJson(Map<String, dynamic> json) =>
      _$SeatingSectionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeatingSectionModelToJson(this);
}

@JsonSerializable()
class SeatingTableModel extends SeatingTable {
  const SeatingTableModel({
    required super.id,
    required super.seatingSectionId,
    required super.tableNumber,
    required super.tableShape,
    required super.capacity,
    required super.positionX,
    required super.positionY,
    super.rotationDegrees,
    super.currentOccupied,
    super.tableStatus,
    super.specialFeatures,
    super.notes,
  });

  factory SeatingTableModel.fromJson(Map<String, dynamic> json) =>
      _$SeatingTableModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeatingTableModelToJson(this);
}

@JsonSerializable()
class TableAssignmentModel extends TableAssignment {
  const TableAssignmentModel({
    required super.id,
    required super.seatingTableId,
    super.guestFamilyId,
    super.guestPersonId,
    required super.seatCount,
    super.assignmentType,
    super.preferencesNotes,
  });

  factory TableAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$TableAssignmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableAssignmentModelToJson(this);
}
