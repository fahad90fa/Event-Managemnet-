import '../entities/budget_prediction_entities.dart';

abstract class BudgetPredictionRepository {
  Future<BudgetPrediction> getBudgetPrediction({
    required int guestCount,
    required String city,
    required double targetBudget,
    required List<String> selectedServices,
  });

  Future<List<BudgetPrediction>> getPredictionHistory(String weddingId);
}
