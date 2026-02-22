import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../data/models/analytics_models.dart';

class TaskAnalyticsCard extends StatelessWidget {
  final TaskAnalytics taskAnalytics;

  const TaskAnalyticsCard({
    super.key,
    required this.taskAnalytics,
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
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.task_alt,
                      color: Color(0xFF9C27B0), size: 28),
                ),
                const SizedBox(width: 16),
                const Text('Task Analytics',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),

            // Chart & Summary Row
            Row(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFF4CAF50),
                          value: taskAnalytics.summary.completed.toDouble(),
                          title: '',
                          radius: 15,
                        ),
                        PieChartSectionData(
                          color: Colors.blue,
                          value: taskAnalytics.summary.inProgress.toDouble(),
                          title: '',
                          radius: 15,
                        ),
                        PieChartSectionData(
                          color: Colors.grey.withValues(alpha: 0.3),
                          value: taskAnalytics.summary.notStarted.toDouble(),
                          title: '',
                          radius: 15,
                        ),
                        if (taskAnalytics.summary.overdue > 0)
                          PieChartSectionData(
                            color: const Color(0xFFEB1555),
                            value: taskAnalytics.summary.overdue.toDouble(),
                            title: '',
                            radius: 18,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildLegendItem(
                          'Completed',
                          taskAnalytics.summary.completed,
                          const Color(0xFF4CAF50)),
                      _buildLegendItem('In Progress',
                          taskAnalytics.summary.inProgress, Colors.blue),
                      _buildLegendItem('Not Started',
                          taskAnalytics.summary.notStarted, Colors.grey),
                      if (taskAnalytics.summary.overdue > 0)
                        _buildLegendItem(
                            'Overdue',
                            taskAnalytics.summary.overdue,
                            const Color(0xFFEB1555)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Critical Tasks List
            if (taskAnalytics.criticalPath.isNotEmpty) ...[
              const Text(
                'Critical Path',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...taskAnalytics.criticalPath
                  .take(3)
                  .map((task) => _buildCriticalTaskItem(task)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          Text('$value',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCriticalTaskItem(CriticalTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111328),
        borderRadius: BorderRadius.circular(8),
        border: Border(
            left:
                BorderSide(color: _getPriorityColor(task.priority), width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.task,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${task.daysRemaining} days left',
                style: TextStyle(
                    color: _getDaysColor(task.daysRemaining), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (task.blocking.isNotEmpty)
            Text(
              'Blocking: ${task.blocking.length} tasks',
              style:
                  TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return const Color(0xFFEB1555);
      case 'high':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _getDaysColor(int days) {
    if (days < 7) return const Color(0xFFEB1555);
    if (days < 14) return Colors.orange;
    return const Color(0xFF4CAF50);
  }
}
