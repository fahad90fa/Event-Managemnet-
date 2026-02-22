import '../models/analytics_models.dart';

/// Mock Analytics Service for development and testing
/// Provides realistic sample data without requiring backend
class MockAnalyticsService {
  /// Get mock analytics dashboard data
  Future<WeddingAnalyticsDashboard> getAnalyticsDashboard(
      String weddingId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return WeddingAnalyticsDashboard(
      overview: _getMockOverview(),
      guestAnalytics: _getMockGuestAnalytics(),
      budgetAnalytics: _getMockBudgetAnalytics(),
      vendorAnalytics: _getMockVendorAnalytics(),
      taskAnalytics: _getMockTaskAnalytics(),
    );
  }

  AnalyticsOverview _getMockOverview() {
    return const AnalyticsOverview(
      weddingId: 'mock-wedding-123',
      weddingTitle: 'Ahmed & Fatima Wedding',
      planningStartDate: '2023-12-01',
      firstEventDate: '2024-06-10',
      daysUntilFirstEvent: 75,
      overallProgress: 62.5,
      healthScore: 87,
      alerts: [
        AnalyticsAlert(
          type: 'warning',
          category: 'budget',
          message: "You've spent 58% of budget with 75 days remaining",
          action: 'Review upcoming expenses',
          priority: 7,
        ),
        AnalyticsAlert(
          type: 'critical',
          category: 'tasks',
          message: '5 tasks are overdue',
          action: 'View overdue tasks',
          priority: 9,
        ),
        AnalyticsAlert(
          type: 'info',
          category: 'guests',
          message: '115 guests haven\'t responded yet',
          action: 'Send reminders',
          priority: 5,
        ),
      ],
    );
  }

  GuestAnalytics _getMockGuestAnalytics() {
    return const GuestAnalytics(
      summary: GuestSummary(
        totalInvited: 450,
        confirmed: 320,
        declined: 15,
        pending: 115,
        confirmationRate: 71.1,
      ),
      bySide: GuestBySide(
        bride: SideStats(
          invited: 220,
          confirmed: 165,
          rate: 75.0,
        ),
        groom: SideStats(
          invited: 230,
          confirmed: 155,
          rate: 67.4,
        ),
      ),
      byEvent: [
        GuestByEvent(
          eventId: 'event-1',
          eventName: 'Mehndi',
          invited: 200,
          confirmed: 145,
          rate: 72.5,
        ),
        GuestByEvent(
          eventId: 'event-2',
          eventName: 'Barat',
          invited: 450,
          confirmed: 320,
          rate: 71.1,
        ),
        GuestByEvent(
          eventId: 'event-3',
          eventName: 'Walima',
          invited: 400,
          confirmed: 285,
          rate: 71.3,
        ),
      ],
      predictions: GuestPredictions(
        expectedFinalAttendance: 385,
        confidence: 0.82,
      ),
    );
  }

  BudgetAnalytics _getMockBudgetAnalytics() {
    return const BudgetAnalytics(
      summary: BudgetSummary(
        totalBudget: 1500000,
        spent: 875000,
        committed: 450000,
        remaining: 175000,
        percentSpent: 58.3,
      ),
      byCategory: [
        BudgetByCategory(
          category: 'venue',
          categoryName: 'Venue',
          budgeted: 350000,
          spent: 300000,
          committed: 50000,
          remaining: 0,
          percentUsed: 100,
          status: 'on_budget',
        ),
        BudgetByCategory(
          category: 'catering',
          categoryName: 'Catering',
          budgeted: 500000,
          spent: 100000,
          committed: 400000,
          remaining: 0,
          percentUsed: 100,
          status: 'at_limit',
        ),
        BudgetByCategory(
          category: 'decor',
          categoryName: 'Decoration',
          budgeted: 200000,
          spent: 50000,
          committed: 0,
          remaining: 150000,
          percentUsed: 25,
          status: 'under_budget',
        ),
        BudgetByCategory(
          category: 'photography',
          categoryName: 'Photography',
          budgeted: 150000,
          spent: 150000,
          committed: 0,
          remaining: 0,
          percentUsed: 100,
          status: 'on_budget',
        ),
        BudgetByCategory(
          category: 'makeup',
          categoryName: 'Makeup & Hair',
          budgeted: 100000,
          spent: 75000,
          committed: 25000,
          remaining: 0,
          percentUsed: 100,
          status: 'on_budget',
        ),
        BudgetByCategory(
          category: 'clothing',
          categoryName: 'Clothing',
          budgeted: 200000,
          spent: 200000,
          committed: 0,
          remaining: 0,
          percentUsed: 100,
          status: 'over_budget',
        ),
      ],
      forecast: BudgetForecast(
        projectedFinalCost: 1475000,
        underOverBudget: -25000,
        confidence: 0.78,
      ),
    );
  }

  VendorAnalytics _getMockVendorAnalytics() {
    return const VendorAnalytics(
      summary: VendorSummary(
        vendorsContacted: 34,
        quotesReceived: 18,
        vendorsBooked: 7,
        pendingDecisions: 3,
      ),
      byCategory: [
        VendorByCategory(
          category: 'venue',
          contacted: 8,
          quotes: 5,
          booked: 1,
          averageQuote: 320000,
          yourBooking: 300000,
          savingsVsAverage: 20000,
        ),
        VendorByCategory(
          category: 'catering',
          contacted: 6,
          quotes: 4,
          booked: 1,
          averageQuote: 520000,
          yourBooking: 500000,
          savingsVsAverage: 20000,
        ),
        VendorByCategory(
          category: 'photography',
          contacted: 5,
          quotes: 3,
          booked: 1,
          averageQuote: 165000,
          yourBooking: 150000,
          savingsVsAverage: 15000,
        ),
        VendorByCategory(
          category: 'decor',
          contacted: 7,
          quotes: 3,
          booked: 0,
          averageQuote: 180000,
          yourBooking: null,
          savingsVsAverage: null,
        ),
        VendorByCategory(
          category: 'makeup',
          contacted: 4,
          quotes: 2,
          booked: 1,
          averageQuote: 85000,
          yourBooking: 75000,
          savingsVsAverage: 10000,
        ),
      ],
    );
  }

  TaskAnalytics _getMockTaskAnalytics() {
    return const TaskAnalytics(
      summary: TaskSummary(
        totalTasks: 89,
        completed: 45,
        inProgress: 23,
        notStarted: 21,
        overdue: 5,
        completionRate: 50.6,
      ),
      criticalPath: [
        CriticalTask(
          taskId: 'task-1',
          task: 'Book Barat venue',
          dueDate: '2024-04-01',
          daysRemaining: 15,
          blocking: ['task-2', 'task-3'],
          priority: 'critical',
        ),
        CriticalTask(
          taskId: 'task-2',
          task: 'Finalize catering menu',
          dueDate: '2024-04-10',
          daysRemaining: 24,
          blocking: ['task-5'],
          priority: 'high',
        ),
        CriticalTask(
          taskId: 'task-3',
          task: 'Send wedding invitations',
          dueDate: '2024-04-15',
          daysRemaining: 29,
          blocking: [],
          priority: 'high',
        ),
        CriticalTask(
          taskId: 'task-4',
          task: 'Book makeup artist',
          dueDate: '2024-05-01',
          daysRemaining: 45,
          blocking: [],
          priority: 'medium',
        ),
      ],
    );
  }

  /// Get analytics for specific date range
  Future<WeddingAnalyticsDashboard> getAnalyticsForDateRange(
    String weddingId,
    DateTime from,
    DateTime to,
  ) async {
    // In real implementation, this would filter data by date range
    return getAnalyticsDashboard(weddingId);
  }

  /// Export analytics report
  Future<String> exportAnalyticsReport(
    String weddingId,
    String format, // pdf, excel
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    // Return mock download URL
    return 'https://api.weddingos.com/downloads/reports/mock-report-123.$format';
  }
}
