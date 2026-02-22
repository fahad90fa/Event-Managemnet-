import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/budget_ai_bloc.dart';
import '../../domain/entities/budget_prediction_entities.dart';
import '../../../../core/config/localization/language_bloc.dart';
import '../../../../core/config/localization/translator.dart';

class BudgetAiPage extends StatefulWidget {
  const BudgetAiPage({super.key});

  @override
  State<BudgetAiPage> createState() => _BudgetAiPageState();
}

class _BudgetAiPageState extends State<BudgetAiPage> {
  final _guestController = TextEditingController(text: '300');
  final _budgetController = TextEditingController(text: '1500000');
  String _selectedCity = 'Lahore';
  final List<String> _cities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Faisalabad',
    'Multan'
  ];

  @override
  void dispose() {
    _guestController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, lang) {
        return Scaffold(
          appBar: AppBar(
            title: Text("budget_predictor".tr(lang.language),
                style:
                    GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                onPressed: () =>
                    context.read<LanguageBloc>().add(ToggleLanguage()),
                child: Text("language_toggle".tr(lang.language),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInputSection(lang.language),
                const SizedBox(height: 24),
                BlocBuilder<BudgetAiBloc, BudgetAiState>(
                  builder: (context, state) {
                    if (state is BudgetAiLoading) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (state is BudgetAiLoaded) {
                      return _buildPredictionResult(
                          state.prediction, lang.language);
                    } else if (state is BudgetAiError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)));
                    }
                    return _buildEmptyState(lang.language);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputSection(AppLanguage language) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("planning_details".tr(language),
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guestController,
                    decoration: InputDecoration(
                        labelText: "guest_count".tr(language),
                        border: const OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCity,
                    items: _cities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCity = val!),
                    decoration: InputDecoration(
                        labelText: "city".tr(language),
                        border: const OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _budgetController,
              decoration: InputDecoration(
                labelText: "target_budget".tr(language),
                border: const OutlineInputBorder(),
                prefixText: 'Rs. ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.read<BudgetAiBloc>().add(RequestPrediction(
                        guestCount: int.parse(_guestController.text),
                        city: _selectedCity,
                        targetBudget: double.parse(_budgetController.text),
                        selectedServices: const [
                          'Venue',
                          'Catering',
                          'Photo',
                          'Attire'
                        ],
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("generate_forecast".tr(language)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionResult(
      BudgetPrediction prediction, AppLanguage language) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("prediction_result".tr(language),
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                '${(prediction.confidenceScore * 100).toInt()}% Confidence',
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMarketInsights(prediction, language),
        const SizedBox(height: 24),
        _buildBudgetChart(prediction),
        const SizedBox(height: 24),
        Text("category_breakdown".tr(language),
            style:
                GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prediction.categories.length,
          itemBuilder: (context, index) {
            final cat = prediction.categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text(cat.categoryName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(currencyFormat.format(cat.estimatedAmount)),
                trailing: Text('${cat.estimatedPercentage.toInt()}%'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AI Recommendation:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blue)),
                        const SizedBox(height: 4),
                        Text(cat.recommendation,
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 12),
                        const Text('Cost Drivers:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey)),
                        Wrap(
                          spacing: 8,
                          children: cat.commonCostDrivers
                              .map((d) => Chip(
                                    label: Text(d,
                                        style: const TextStyle(fontSize: 10)),
                                    visualDensity: VisualDensity.compact,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMarketInsights(
      BudgetPrediction prediction, AppLanguage language) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text("market_intelligence".tr(language),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prediction.aiInsights['message'] ?? 'Optimal market rates applied.',
            style: GoogleFonts.inter(
                fontSize: 13, color: Colors.black87, height: 1.4),
          ),
          if (prediction.aiInsights.containsKey('city_context')) ...[
            const SizedBox(height: 8),
            Text(
              prediction.aiInsights['city_context']!,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetChart(BudgetPrediction prediction) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 60,
          sections: List.generate(prediction.categories.length, (i) {
            final cat = prediction.categories[i];
            return PieChartSectionData(
              color: colors[i % colors.length],
              value: cat.estimatedPercentage,
              title: '${cat.estimatedPercentage.toInt()}%',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLanguage language) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(Icons.auto_awesome,
            size: 80, color: Colors.blue.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        Text(
          language == AppLanguage.urdu
              ? 'کیا آپ اپنا بجٹ بہتر بنانا چاہتے ہیں؟'
              : 'Ready to optimize your budget?',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
        ),
        Text(
          language == AppLanguage.urdu
              ? 'پیشگوئی کے لیے اوپر تفصیلات درج کریں۔'
              : 'Enter details above to generate prediction.',
          style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
