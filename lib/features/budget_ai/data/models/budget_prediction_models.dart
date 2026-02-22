import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/budget_prediction_entities.dart';

part 'budget_prediction_models.g.dart';

@JsonSerializable(explicitToJson: true)
class BudgetPredictionModel extends BudgetPrediction {
  const BudgetPredictionModel({
    required super.id,
    required super.weddingProjectId,
    required super.totalEstimatedBudget,
    required List<BudgetCategoryPredictionModel> categories,
    required super.confidenceScore,
    super.aiInsights,
    required super.createdAt,
  }) : super(categories: categories);

  @override
  List<BudgetCategoryPredictionModel> get categories =>
      super.categories.map((e) => e as BudgetCategoryPredictionModel).toList();

  factory BudgetPredictionModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetPredictionModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetPredictionModelToJson(this);
}

@JsonSerializable()
class BudgetCategoryPredictionModel extends BudgetCategoryPrediction {
  const BudgetCategoryPredictionModel({
    required super.categoryName,
    required super.estimatedPercentage,
    required super.estimatedAmount,
    super.commonCostDrivers,
    required super.recommendation,
  });

  factory BudgetCategoryPredictionModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetCategoryPredictionModelFromJson(json);
  Map<String, dynamic> toJson() => _$BudgetCategoryPredictionModelToJson(this);
}
