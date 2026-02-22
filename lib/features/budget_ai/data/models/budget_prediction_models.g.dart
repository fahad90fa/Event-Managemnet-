// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_prediction_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetPredictionModel _$BudgetPredictionModelFromJson(
        Map<String, dynamic> json) =>
    BudgetPredictionModel(
      id: json['id'] as String,
      weddingProjectId: json['weddingProjectId'] as String,
      totalEstimatedBudget: (json['totalEstimatedBudget'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) =>
              BudgetCategoryPredictionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      aiInsights: json['aiInsights'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BudgetPredictionModelToJson(
        BudgetPredictionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weddingProjectId': instance.weddingProjectId,
      'totalEstimatedBudget': instance.totalEstimatedBudget,
      'confidenceScore': instance.confidenceScore,
      'aiInsights': instance.aiInsights,
      'createdAt': instance.createdAt.toIso8601String(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };

BudgetCategoryPredictionModel _$BudgetCategoryPredictionModelFromJson(
        Map<String, dynamic> json) =>
    BudgetCategoryPredictionModel(
      categoryName: json['categoryName'] as String,
      estimatedPercentage: (json['estimatedPercentage'] as num).toDouble(),
      estimatedAmount: (json['estimatedAmount'] as num).toDouble(),
      commonCostDrivers: (json['commonCostDrivers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendation: json['recommendation'] as String,
    );

Map<String, dynamic> _$BudgetCategoryPredictionModelToJson(
        BudgetCategoryPredictionModel instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'estimatedPercentage': instance.estimatedPercentage,
      'estimatedAmount': instance.estimatedAmount,
      'commonCostDrivers': instance.commonCostDrivers,
      'recommendation': instance.recommendation,
    };
