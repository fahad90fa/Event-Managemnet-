import 'package:equatable/equatable.dart';

class BudgetPrediction extends Equatable {
  final String id;
  final String weddingProjectId;
  final double totalEstimatedBudget;
  final List<BudgetCategoryPrediction> categories;
  final double confidenceScore;
  final Map<String, dynamic> aiInsights;
  final DateTime createdAt;

  const BudgetPrediction({
    required this.id,
    required this.weddingProjectId,
    required this.totalEstimatedBudget,
    required this.categories,
    required this.confidenceScore,
    this.aiInsights = const {},
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        weddingProjectId,
        totalEstimatedBudget,
        categories,
        confidenceScore,
        aiInsights,
        createdAt
      ];
}

class BudgetCategoryPrediction extends Equatable {
  final String categoryName;
  final double estimatedPercentage;
  final double estimatedAmount;
  final List<String> commonCostDrivers;
  final String recommendation;

  const BudgetCategoryPrediction({
    required this.categoryName,
    required this.estimatedPercentage,
    required this.estimatedAmount,
    this.commonCostDrivers = const [],
    required this.recommendation,
  });

  @override
  List<Object?> get props => [
        categoryName,
        estimatedPercentage,
        estimatedAmount,
        commonCostDrivers,
        recommendation
      ];
}
