import '../../domain/entities/seating_entities.dart';
import '../../domain/repositories/seating_repository.dart';
import '../models/seating_models.dart';
import '../services/seating_api_service.dart';

class SeatingRepositoryImpl implements SeatingRepository {
  final SeatingApiService apiService;

  SeatingRepositoryImpl(this.apiService);

  @override
  Future<List<SeatingLayout>> getLayouts(String eventId) async {
    return await apiService.getLayouts(eventId);
  }

  @override
  Future<SeatingLayout> createLayout(SeatingLayout layout) async {
    final model = SeatingLayoutModel(
      id: layout.id,
      eventId: layout.eventId,
      layoutName: layout.layoutName,
      layoutType: layout.layoutType,
      totalCapacity: layout.totalCapacity,
      roomDimensions: layout.roomDimensions,
      canvasData: layout.canvasData,
      isActive: layout.isActive,
    );
    return await apiService.createLayout(model);
  }

  @override
  Future<List<SeatingSection>> getSections(String layoutId) async {
    return await apiService.getSections(layoutId);
  }

  @override
  Future<SeatingSection> addSection(SeatingSection section) async {
    final model = SeatingSectionModel(
      id: section.id,
      seatingLayoutId: section.seatingLayoutId,
      sectionName: section.sectionName,
      sectionType: section.sectionType,
      colorCode: section.colorCode,
      positionCoordinates: section.positionCoordinates,
      capacity: section.capacity,
      specialAmenities: section.specialAmenities,
      sortOrder: section.sortOrder,
    );
    return await apiService.addSection(model);
  }

  @override
  Future<List<SeatingTable>> getTables(String sectionId) async {
    return await apiService.getTables(sectionId);
  }

  @override
  Future<List<SeatingTable>> autoGenerateTables(
      String sectionId, Map<String, dynamic> params) async {
    return await apiService.autoGenerateTables(sectionId, params);
  }

  @override
  Future<TableAssignment> assignGuest(TableAssignment assignment) async {
    final model = TableAssignmentModel(
      id: assignment.id,
      seatingTableId: assignment.seatingTableId,
      guestFamilyId: assignment.guestFamilyId,
      guestPersonId: assignment.guestPersonId,
      seatCount: assignment.seatCount,
      assignmentType: assignment.assignmentType,
      preferencesNotes: assignment.preferencesNotes,
    );
    return await apiService.assignGuest(model);
  }

  @override
  Future<void> assignGuestToTable(
      String tableId, String guestId, int count) async {
    // For now, this is a mock-thru to the same logic
    await apiService.updateTablePosition(tableId, {'occupied_change': count});
  }

  @override
  Future<List<TableAssignment>> getTableAssignments(String tableId) async {
    return await apiService.getTableAssignments(tableId);
  }

  @override
  Future<void> updateTablePosition(String tableId, double x, double y) async {
    await apiService.updateTablePosition(tableId, {
      'positionX': x,
      'positionY': y,
    });
  }
}
