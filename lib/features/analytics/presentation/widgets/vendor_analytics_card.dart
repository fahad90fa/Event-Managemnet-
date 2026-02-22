import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/models/analytics_models.dart';

class VendorAnalyticsCard extends StatelessWidget {
  final VendorAnalytics vendorAnalytics;

  const VendorAnalyticsCard({
    super.key,
    required this.vendorAnalytics,
  });

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
                    color: const Color(0xFFFFA726).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.store,
                      color: Color(0xFFFFA726), size: 28),
                ),
                const SizedBox(width: 16),
                const Text('Vendor Analytics',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Contacted',
                    '${vendorAnalytics.summary.vendorsContacted}', Colors.blue),
                _buildStatItem('Quotes',
                    '${vendorAnalytics.summary.quotesReceived}', Colors.orange),
                _buildStatItem('Booked',
                    '${vendorAnalytics.summary.vendorsBooked}', Colors.green),
              ],
            ),
            const SizedBox(height: 32),

            // Bar Chart
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10, // Adjust dynamically in real app
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() >=
                              vendorAnalytics.byCategory.length) {
                            return const SizedBox.shrink();
                          }
                          final category =
                              vendorAnalytics.byCategory[value.toInt()];
                          // Show abbreviated category names
                          String text =
                              category.category.substring(0, 3).toUpperCase();
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(text,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 10)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      vendorAnalytics.byCategory.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: data.contacted.toDouble(),
                          color: Colors.blue.withValues(alpha: 0.5),
                          width: 8,
                        ),
                        BarChartRodData(
                          toY: data.booked.toDouble(),
                          color: Colors.green,
                          width: 8,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Contacted', Colors.blue.withValues(alpha: 0.5)),
                const SizedBox(width: 16),
                _buildLegendItem('Booked', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label,
            style:
                TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
      ],
    );
  }
}
