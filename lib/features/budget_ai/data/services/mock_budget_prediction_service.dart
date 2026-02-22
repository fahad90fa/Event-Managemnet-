import '../../domain/entities/budget_prediction_entities.dart';
import '../../domain/repositories/budget_prediction_repository.dart';

class MockBudgetPredictionService implements BudgetPredictionRepository {
  @override
  Future<BudgetPrediction> getBudgetPrediction({
    required int guestCount,
    required String city,
    required double targetBudget,
    required List<String> selectedServices,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    // City-based multipliers based on local market research
    double multiplier = 1.0;
    String trendMessage = "";

    switch (city) {
      case 'Islamabad':
        multiplier = 1.25; // Premium service & venue tax
        trendMessage =
            "Islamabad venues currently have a 'Capital Premium'. Costs are 25% higher than average.";
        break;
      case 'Karachi':
        multiplier = 1.15; // High logistics & security costs
        trendMessage =
            "Karachi logistics and decor costs are rising due to supply chain factors.";
        break;
      case 'Lahore':
        multiplier = 1.10; // High food standards & catering demand
        trendMessage =
            "Lahore catering standards are exceptionally high. Budget reflects 'Gourmet' benchmarks.";
        break;
      default:
        multiplier = 1.0;
        trendMessage = "Standard market rates applied for $city.";
    }

    // Adjusting base percentages
    final venuePercent = 0.35 * multiplier;
    const cateringPercent =
        0.40; // Food is fixed but quality scales with budget
    const photographyPercent = 0.10;

    return BudgetPrediction(
      id: 'pred-${DateTime.now().millisecondsSinceEpoch}',
      weddingProjectId: 'wedding-1',
      totalEstimatedBudget: targetBudget,
      confidenceScore: 0.92,
      createdAt: DateTime.now(),
      aiInsights: {
        'trend': city == 'Islamabad' ? 'Aggressive' : 'Stable',
        'message': trendMessage,
        'city_context': "Based on $guestCount guests in $city.",
      },
      categories: [
        BudgetCategoryPrediction(
          categoryName: 'Venue',
          estimatedPercentage: venuePercent * 100,
          estimatedAmount: targetBudget * venuePercent,
          recommendation: city == 'Karachi'
              ? 'Consider DHA or Karsaz marquees for better security and valet facilities.'
              : 'Farmhouses in $city outskirts can save you 20% on booking fees.',
          commonCostDrivers: const ['Generator Fuel', 'Security', 'Lighting'],
        ),
        BudgetCategoryPrediction(
          categoryName: 'Catering',
          estimatedPercentage: cateringPercent * 100,
          estimatedAmount: targetBudget * cateringPercent,
          recommendation:
              'In $city, guests expect at least 2 main courses + 1 desert. Avoid "Per Head" billing for >500 guests.',
          commonCostDrivers: const [
            'Mutton Variance',
            'Service Staff',
            'Fresh Salads'
          ],
        ),
        BudgetCategoryPrediction(
          categoryName: 'Photography',
          estimatedPercentage: photographyPercent * 100,
          estimatedAmount: targetBudget * photographyPercent,
          recommendation:
              'Top $city cinematographers book 6 months in advance.',
          commonCostDrivers: const ['Same Day Edit', 'Drone Coverage'],
        ),
      ],
    );
  }

  @override
  Future<List<BudgetPrediction>> getPredictionHistory(String weddingId) async {
    return [];
  }
}
