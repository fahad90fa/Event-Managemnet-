import 'dart:math';
import '../../domain/entities/seating_entities.dart';
import '../../domain/repositories/seating_repository.dart';

class MockSeatingService implements SeatingRepository {
  final List<SeatingLayout> _layouts = [];
  final List<SeatingSection> _sections = [];
  final List<SeatingTable> _tables = [];
  final List<TableAssignment> _assignments = [];

  MockSeatingService() {
    _generateMockData();
  }

  void _generateMockData() {
    const layoutId = 'layout-1';
    _layouts.add(const SeatingLayout(
      id: layoutId,
      eventId: 'event-1',
      layoutName: 'Main Hall Mehndi',
      layoutType: SeatingLayoutType.banquetRounds,
      totalCapacity: 500,
      roomDimensions: {'width': 100, 'length': 150},
    ));

    _sections.addAll(const [
      SeatingSection(
        id: 'section-1',
        seatingLayoutId: layoutId,
        sectionName: 'VIP Area',
        sectionType: SeatingSectionType.vip,
        colorCode: '#FFD700',
        positionCoordinates: {'x': 10, 'y': 10, 'w': 80, 'h': 30},
        capacity: 50,
      ),
      SeatingSection(
        id: 'section-2',
        seatingLayoutId: layoutId,
        sectionName: 'Ladies Section',
        sectionType: SeatingSectionType.ladiesOnly,
        colorCode: '#FF69B4',
        positionCoordinates: {'x': 10, 'y': 50, 'w': 80, 'h': 40},
        capacity: 200,
      ),
    ]);

    for (int i = 1; i <= 5; i++) {
      _tables.add(SeatingTable(
        id: 'table-$i',
        seatingSectionId: 'section-1',
        tableNumber: 'VIP-$i',
        tableShape: TableShape.round,
        capacity: 10,
        positionX: 20.0 + (i * 15),
        positionY: 20.0,
        currentOccupied: i % 10,
        tableStatus: i % 2 == 0 ? TableStatus.partial : TableStatus.empty,
      ));
    }
  }

  @override
  Future<List<SeatingLayout>> getLayouts(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _layouts.where((l) => l.eventId == eventId).toList();
  }

  @override
  Future<SeatingLayout> createLayout(SeatingLayout layout) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _layouts.add(layout);
    return layout;
  }

  @override
  Future<List<SeatingSection>> getSections(String layoutId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sections.where((s) => s.seatingLayoutId == layoutId).toList();
  }

  @override
  Future<SeatingSection> addSection(SeatingSection section) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _sections.add(section);
    return section;
  }

  @override
  Future<List<SeatingTable>> getTables(String sectionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _tables.where((t) => t.seatingSectionId == sectionId).toList();
  }

  @override
  Future<List<SeatingTable>> autoGenerateTables(
      String sectionId, Map<String, dynamic> params) async {
    await Future.delayed(const Duration(seconds: 1));
    final section = _sections.firstWhere((s) => s.id == sectionId);
    final count = (section.capacity / (params['table_capacity'] ?? 10)).ceil();
    final List<SeatingTable> newTables = [];

    for (int i = 1; i <= count; i++) {
      final t = SeatingTable(
        id: 'table-gen-${Random().nextInt(10000)}',
        seatingSectionId: sectionId,
        tableNumber: 'T-$i',
        tableShape: params['table_shape'] == 'round'
            ? TableShape.round
            : TableShape.rectangle,
        capacity: params['table_capacity'] ?? 10,
        positionX: 10.0 + (i * 10) % 80,
        positionY: 10.0 + (i / 8) * 20,
      );
      newTables.add(t);
      _tables.add(t);
    }
    return newTables;
  }

  @override
  Future<TableAssignment> assignGuest(TableAssignment assignment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _assignments.add(assignment);
    return assignment;
  }

  @override
  Future<void> assignGuestToTable(
      String tableId, String guestId, int count) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      final oldTable = _tables[index];
      _tables[index] = SeatingTable(
        id: oldTable.id,
        seatingSectionId: oldTable.seatingSectionId,
        tableNumber: oldTable.tableNumber,
        tableShape: oldTable.tableShape,
        capacity: oldTable.capacity,
        positionX: oldTable.positionX,
        positionY: oldTable.positionY,
        rotationDegrees: oldTable.rotationDegrees,
        currentOccupied: oldTable.currentOccupied + count,
        tableStatus: (oldTable.currentOccupied + count) >= oldTable.capacity
            ? TableStatus.full
            : TableStatus.partial,
      );
    }
  }

  @override
  Future<List<TableAssignment>> getTableAssignments(String tableId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _assignments.where((a) => a.seatingTableId == tableId).toList();
  }

  @override
  Future<void> updateTablePosition(String tableId, double x, double y) async {
    final index = _tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      final oldTable = _tables[index];
      _tables[index] = SeatingTable(
        id: oldTable.id,
        seatingSectionId: oldTable.seatingSectionId,
        tableNumber: oldTable.tableNumber,
        tableShape: oldTable.tableShape,
        capacity: oldTable.capacity,
        positionX: x,
        positionY: y,
        rotationDegrees: oldTable.rotationDegrees,
        currentOccupied: oldTable.currentOccupied,
        tableStatus: oldTable.tableStatus,
        specialFeatures: oldTable.specialFeatures,
        notes: oldTable.notes,
      );
    }
  }
}
