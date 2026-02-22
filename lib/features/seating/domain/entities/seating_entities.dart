import 'package:equatable/equatable.dart';

enum SeatingLayoutType {
  banquetRounds,
  longTables,
  theaterRows,
  customShapes,
  mixed
}

class SeatingLayout extends Equatable {
  final String id;
  final String eventId;
  final String layoutName;
  final SeatingLayoutType layoutType;
  final int totalCapacity;
  final Map<String, dynamic> roomDimensions;
  final Map<String, dynamic>? canvasData;
  final bool isActive;

  const SeatingLayout({
    required this.id,
    required this.eventId,
    required this.layoutName,
    required this.layoutType,
    required this.totalCapacity,
    required this.roomDimensions,
    this.canvasData,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        layoutName,
        layoutType,
        totalCapacity,
        roomDimensions,
        canvasData,
        isActive
      ];
}

enum SeatingSectionType {
  vip,
  family,
  ladiesOnly,
  gentsOnly,
  mixed,
  children,
  elderly,
  stageProximity
}

class SeatingSection extends Equatable {
  final String id;
  final String seatingLayoutId;
  final String sectionName;
  final SeatingSectionType sectionType;
  final String colorCode;
  final Map<String, dynamic> positionCoordinates;
  final int capacity;
  final List<String>? specialAmenities;
  final int sortOrder;

  const SeatingSection({
    required this.id,
    required this.seatingLayoutId,
    required this.sectionName,
    required this.sectionType,
    required this.colorCode,
    required this.positionCoordinates,
    required this.capacity,
    this.specialAmenities,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        seatingLayoutId,
        sectionName,
        sectionType,
        colorCode,
        positionCoordinates,
        capacity,
        specialAmenities,
        sortOrder
      ];
}

enum TableShape { round, rectangle, square, oval, custom }

enum TableStatus { empty, partial, full, reserved }

class SeatingTable extends Equatable {
  final String id;
  final String seatingSectionId;
  final String tableNumber;
  final TableShape tableShape;
  final int capacity;
  final double positionX;
  final double positionY;
  final double rotationDegrees;
  final int currentOccupied;
  final TableStatus tableStatus;
  final List<String>? specialFeatures;
  final String? notes;

  const SeatingTable({
    required this.id,
    required this.seatingSectionId,
    required this.tableNumber,
    required this.tableShape,
    required this.capacity,
    required this.positionX,
    required this.positionY,
    this.rotationDegrees = 0,
    this.currentOccupied = 0,
    this.tableStatus = TableStatus.empty,
    this.specialFeatures,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        seatingSectionId,
        tableNumber,
        tableShape,
        capacity,
        positionX,
        positionY,
        rotationDegrees,
        currentOccupied,
        tableStatus,
        specialFeatures,
        notes
      ];
}

enum AssignmentType { confirmed, tentative, placeholder }

class TableAssignment extends Equatable {
  final String id;
  final String seatingTableId;
  final String? guestFamilyId;
  final String? guestPersonId;
  final int seatCount;
  final AssignmentType assignmentType;
  final String? preferencesNotes;

  const TableAssignment({
    required this.id,
    required this.seatingTableId,
    this.guestFamilyId,
    this.guestPersonId,
    required this.seatCount,
    this.assignmentType = AssignmentType.confirmed,
    this.preferencesNotes,
  });

  @override
  List<Object?> get props => [
        id,
        seatingTableId,
        guestFamilyId,
        guestPersonId,
        seatCount,
        assignmentType,
        preferencesNotes
      ];
}
