import 'package:flutter/material.dart';
import '../../data/models/analytics_models.dart';
import '../../data/services/mock_analytics_service.dart';
import '../widgets/analytics_overview_card.dart';
import '../widgets/guest_analytics_card.dart';
import '../widgets/budget_analytics_card.dart';
import '../widgets/vendor_analytics_card.dart';
import '../widgets/task_analytics_card.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  final String weddingId;

  const AnalyticsDashboardPage({
    super.key,
    required this.weddingId,
  });

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  final _analyticsService = MockAnalyticsService();
  bool _isLoading = true;
  WeddingAnalyticsDashboard? _dashboard;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dashboard =
          await _analyticsService.getAnalyticsDashboard(widget.weddingId);
      setState(() {
        _dashboard = dashboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF1D1E33),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEB1555)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEB1555),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading analytics',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadAnalytics,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEB1555),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_dashboard == null) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      color: const Color(0xFFEB1555),
      backgroundColor: const Color(0xFF1D1E33),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview Card
          AnalyticsOverviewCard(overview: _dashboard!.overview),
          const SizedBox(height: 16),

          // Guest Analytics
          GuestAnalyticsCard(guestAnalytics: _dashboard!.guestAnalytics),
          const SizedBox(height: 16),

          // Budget Analytics
          BudgetAnalyticsCard(budgetAnalytics: _dashboard!.budgetAnalytics),
          const SizedBox(height: 16),

          // Vendor Analytics
          VendorAnalyticsCard(vendorAnalytics: _dashboard!.vendorAnalytics),
          const SizedBox(height: 16),

          // Task Analytics
          TaskAnalyticsCard(taskAnalytics: _dashboard!.taskAnalytics),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _exportReport() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEB1555)),
        ),
      ),
    );

    try {
      final url = await _analyticsService.exportAnalyticsReport(
        widget.weddingId,
        'pdf',
      );

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report generated successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Download',
            textColor: Colors.white,
            onPressed: () {
              // In real app, open URL
              debugPrint('Download URL: $url');
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFEB1555),
        ),
      );
    }
  }
}
