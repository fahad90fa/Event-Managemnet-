import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/budget_prediction_models.dart';

part 'budget_prediction_api_service.g.dart';

@RestApi()
abstract class BudgetPredictionApiService {
  factory BudgetPredictionApiService(Dio dio, {String baseUrl}) =
      _BudgetPredictionApiService;

  @POST('/ai/budget/predict')
  Future<BudgetPredictionModel> predictBudget(
      @Body() Map<String, dynamic> params);

  @GET('/ai/budget/history/{weddingId}')
  Future<List<BudgetPredictionModel>> getPredictionHistory(
      @Path('weddingId') String weddingId);
}
