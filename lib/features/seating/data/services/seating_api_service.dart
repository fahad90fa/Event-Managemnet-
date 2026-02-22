import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/seating_models.dart';

part 'seating_api_service.g.dart';

@RestApi()
abstract class SeatingApiService {
  factory SeatingApiService(Dio dio, {String baseUrl}) = _SeatingApiService;

  @GET('/seating/layouts/{eventId}')
  Future<List<SeatingLayoutModel>> getLayouts(@Path('eventId') String eventId);

  @POST('/seating/layouts')
  Future<SeatingLayoutModel> createLayout(@Body() SeatingLayoutModel layout);

  @GET('/seating/sections/{layoutId}')
  Future<List<SeatingSectionModel>> getSections(
      @Path('layoutId') String layoutId);

  @POST('/seating/sections')
  Future<SeatingSectionModel> addSection(@Body() SeatingSectionModel section);

  @GET('/seating/tables/{sectionId}')
  Future<List<SeatingTableModel>> getTables(
      @Path('sectionId') String sectionId);

  @POST('/seating/tables/auto-generate')
  Future<List<SeatingTableModel>> autoGenerateTables(
      @Query('sectionId') String sectionId,
      @Body() Map<String, dynamic> params);

  @POST('/seating/assignments')
  Future<TableAssignmentModel> assignGuest(
      @Body() TableAssignmentModel assignment);

  @GET('/seating/assignments/{tableId}')
  Future<List<TableAssignmentModel>> getTableAssignments(
      @Path('tableId') String tableId);

  @PUT('/seating/tables/{tableId}/position')
  Future<void> updateTablePosition(
    @Path('tableId') String tableId,
    @Body() Map<String, dynamic> position,
  );
}
