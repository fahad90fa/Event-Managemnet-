// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seating_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatingLayoutModel _$SeatingLayoutModelFromJson(Map<String, dynamic> json) =>
    SeatingLayoutModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      layoutName: json['layoutName'] as String,
      layoutType: $enumDecode(_$SeatingLayoutTypeEnumMap, json['layoutType']),
      totalCapacity: (json['totalCapacity'] as num).toInt(),
      roomDimensions: json['roomDimensions'] as Map<String, dynamic>,
      canvasData: json['canvasData'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$SeatingLayoutModelToJson(SeatingLayoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'layoutName': instance.layoutName,
      'layoutType': _$SeatingLayoutTypeEnumMap[instance.layoutType]!,
      'totalCapacity': instance.totalCapacity,
      'roomDimensions': instance.roomDimensions,
      'canvasData': instance.canvasData,
      'isActive': instance.isActive,
    };

const _$SeatingLayoutTypeEnumMap = {
  SeatingLayoutType.banquetRounds: 'banquetRounds',
  SeatingLayoutType.longTables: 'longTables',
  SeatingLayoutType.theaterRows: 'theaterRows',
  SeatingLayoutType.customShapes: 'customShapes',
  SeatingLayoutType.mixed: 'mixed',
};

SeatingSectionModel _$SeatingSectionModelFromJson(Map<String, dynamic> json) =>
    SeatingSectionModel(
      id: json['id'] as String,
      seatingLayoutId: json['seatingLayoutId'] as String,
      sectionName: json['sectionName'] as String,
      sectionType:
          $enumDecode(_$SeatingSectionTypeEnumMap, json['sectionType']),
      colorCode: json['colorCode'] as String,
      positionCoordinates: json['positionCoordinates'] as Map<String, dynamic>,
      capacity: (json['capacity'] as num).toInt(),
      specialAmenities: (json['specialAmenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SeatingSectionModelToJson(
        SeatingSectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seatingLayoutId': instance.seatingLayoutId,
      'sectionName': instance.sectionName,
      'sectionType': _$SeatingSectionTypeEnumMap[instance.sectionType]!,
      'colorCode': instance.colorCode,
      'positionCoordinates': instance.positionCoordinates,
      'capacity': instance.capacity,
      'specialAmenities': instance.specialAmenities,
      'sortOrder': instance.sortOrder,
    };

const _$SeatingSectionTypeEnumMap = {
  SeatingSectionType.vip: 'vip',
  SeatingSectionType.family: 'family',
  SeatingSectionType.ladiesOnly: 'ladiesOnly',
  SeatingSectionType.gentsOnly: 'gentsOnly',
  SeatingSectionType.mixed: 'mixed',
  SeatingSectionType.children: 'children',
  SeatingSectionType.elderly: 'elderly',
  SeatingSectionType.stageProximity: 'stageProximity',
};

SeatingTableModel _$SeatingTableModelFromJson(Map<String, dynamic> json) =>
    SeatingTableModel(
      id: json['id'] as String,
      seatingSectionId: json['seatingSectionId'] as String,
      tableNumber: json['tableNumber'] as String,
      tableShape: $enumDecode(_$TableShapeEnumMap, json['tableShape']),
      capacity: (json['capacity'] as num).toInt(),
      positionX: (json['positionX'] as num).toDouble(),
      positionY: (json['positionY'] as num).toDouble(),
      rotationDegrees: (json['rotationDegrees'] as num?)?.toDouble() ?? 0,
      currentOccupied: (json['currentOccupied'] as num?)?.toInt() ?? 0,
      tableStatus:
          $enumDecodeNullable(_$TableStatusEnumMap, json['tableStatus']) ??
              TableStatus.empty,
      specialFeatures: (json['specialFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SeatingTableModelToJson(SeatingTableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seatingSectionId': instance.seatingSectionId,
      'tableNumber': instance.tableNumber,
      'tableShape': _$TableShapeEnumMap[instance.tableShape]!,
      'capacity': instance.capacity,
      'positionX': instance.positionX,
      'positionY': instance.positionY,
      'rotationDegrees': instance.rotationDegrees,
      'currentOccupied': instance.currentOccupied,
      'tableStatus': _$TableStatusEnumMap[instance.tableStatus]!,
      'specialFeatures': instance.specialFeatures,
      'notes': instance.notes,
    };

const _$TableShapeEnumMap = {
  TableShape.round: 'round',
  TableShape.rectangle: 'rectangle',
  TableShape.square: 'square',
  TableShape.oval: 'oval',
  TableShape.custom: 'custom',
};

const _$TableStatusEnumMap = {
  TableStatus.empty: 'empty',
  TableStatus.partial: 'partial',
  TableStatus.full: 'full',
  TableStatus.reserved: 'reserved',
};

TableAssignmentModel _$TableAssignmentModelFromJson(
        Map<String, dynamic> json) =>
    TableAssignmentModel(
      id: json['id'] as String,
      seatingTableId: json['seatingTableId'] as String,
      guestFamilyId: json['guestFamilyId'] as String?,
      guestPersonId: json['guestPersonId'] as String?,
      seatCount: (json['seatCount'] as num).toInt(),
      assignmentType: $enumDecodeNullable(
              _$AssignmentTypeEnumMap, json['assignmentType']) ??
          AssignmentType.confirmed,
      preferencesNotes: json['preferencesNotes'] as String?,
    );

Map<String, dynamic> _$TableAssignmentModelToJson(
        TableAssignmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seatingTableId': instance.seatingTableId,
      'guestFamilyId': instance.guestFamilyId,
      'guestPersonId': instance.guestPersonId,
      'seatCount': instance.seatCount,
      'assignmentType': _$AssignmentTypeEnumMap[instance.assignmentType]!,
      'preferencesNotes': instance.preferencesNotes,
    };

const _$AssignmentTypeEnumMap = {
  AssignmentType.confirmed: 'confirmed',
  AssignmentType.tentative: 'tentative',
  AssignmentType.placeholder: 'placeholder',
};
