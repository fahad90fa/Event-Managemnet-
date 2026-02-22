import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/models/analytics_models.dart';

class BudgetAnalyticsCard extends StatefulWidget {
  final BudgetAnalytics budgetAnalytics;

  const BudgetAnalyticsCard({
    super.key,
    required this.budgetAnalytics,
  });

  @override
  State<BudgetAnalyticsCard> createState() => _BudgetAnalyticsCardState();
}

class _BudgetAnalyticsCardState extends State<BudgetAnalyticsCard> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1D1E33),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance_wallet,
                      color: Color(0xFF4CAF50), size: 28),
                ),
                const SizedBox(width: 16),
                const Text('Budget Analytics',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            // Summary
            _buildSummaryStats(),
            const SizedBox(height: 32),

            // Pie Chart
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: _showingSections(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildLegend(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Forecast
            if (widget.budgetAnalytics.forecast != null) _buildForecast(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats() {
    final summary = widget.budgetAnalytics.summary;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
              'Total Budget',
              'PKR ${summary.totalBudget / 1000}k',
              Colors.white,
            ),
            _buildStatItem(
              'Remaining',
              'PKR ${summary.remaining / 1000}k',
              const Color(0xFF4CAF50),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: summary.percentSpent / 100,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${summary.percentSpent.toStringAsFixed(1)}% Spent',
            style:
                TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label,
            style:
                TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
      ],
    );
  }

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.budgetAnalytics.byCategory.take(4).map((category) {
        // Simple color mapping logic (can be improved)
        final color = _getColorForCategory(category.category);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Text(
                category.categoryName,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildForecast() {
    final forecast = widget.budgetAnalytics.forecast!;
    final isOverBudget = forecast.underOverBudget > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111328),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverBudget
              ? const Color(0xFFEB1555).withValues(alpha: 0.3)
              : const Color(0xFF4CAF50).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOverBudget ? Icons.trending_up : Icons.trending_down,
            color: isOverBudget
                ? const Color(0xFFEB1555)
                : const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOverBudget
                      ? 'Projected Over Budget'
                      : 'Projected Under Budget',
                  style: TextStyle(
                    color: isOverBudget
                        ? const Color(0xFFEB1555)
                        : const Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'PKR ${forecast.underOverBudget.abs().toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.budgetAnalytics.byCategory.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 0.0; // Hide value when not touched
      final radius = isTouched ? 60.0 : 50.0;
      final category = widget.budgetAnalytics.byCategory[i];
      final color = _getColorForCategory(category.category);

      return PieChartSectionData(
        color: color,
        value: category.percentUsed,
        title: '${category.percentUsed.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'venue':
        return Colors.blue;
      case 'catering':
        return Colors.orange;
      case 'decor':
        return Colors.purple;
      case 'photography':
        return Colors.pink;
      case 'clothing':
        return Colors.red;
      case 'makeup':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
