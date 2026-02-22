import '../../domain/entities/seating_entities.dart';

abstract class SeatingRepository {
  Future<List<SeatingLayout>> getLayouts(String eventId);
  Future<SeatingLayout> createLayout(SeatingLayout layout);
  Future<List<SeatingSection>> getSections(String layoutId);
  Future<SeatingSection> addSection(SeatingSection section);
  Future<List<SeatingTable>> getTables(String sectionId);
  Future<List<SeatingTable>> autoGenerateTables(
      String sectionId, Map<String, dynamic> params);
  Future<TableAssignment> assignGuest(TableAssignment assignment);
  Future<void> assignGuestToTable(String tableId, String guestId, int count);
  Future<List<TableAssignment>> getTableAssignments(String tableId);
  Future<void> updateTablePosition(String tableId, double x, double y);
}
