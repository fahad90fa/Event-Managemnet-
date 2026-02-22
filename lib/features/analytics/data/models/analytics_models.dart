import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytics_models.g.dart';

/// Main analytics dashboard data
@JsonSerializable()
class WeddingAnalyticsDashboard extends Equatable {
  final AnalyticsOverview overview;
  final GuestAnalytics guestAnalytics;
  final BudgetAnalytics budgetAnalytics;
  final VendorAnalytics vendorAnalytics;
  final TaskAnalytics taskAnalytics;

  const WeddingAnalyticsDashboard({
    required this.overview,
    required this.guestAnalytics,
    required this.budgetAnalytics,
    required this.vendorAnalytics,
    required this.taskAnalytics,
  });

  factory WeddingAnalyticsDashboard.fromJson(Map<String, dynamic> json) =>
      _$WeddingAnalyticsDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$WeddingAnalyticsDashboardToJson(this);

  @override
  List<Object?> get props => [
        overview,
        guestAnalytics,
        budgetAnalytics,
        vendorAnalytics,
        taskAnalytics,
      ];
}

/// Overview section
@JsonSerializable()
class AnalyticsOverview extends Equatable {
  final String weddingId;
  final String weddingTitle;
  final String planningStartDate;
  final String firstEventDate;
  final int daysUntilFirstEvent;
  final double overallProgress;
  final int healthScore;
  final List<AnalyticsAlert> alerts;

  const AnalyticsOverview({
    required this.weddingId,
    required this.weddingTitle,
    required this.planningStartDate,
    required this.firstEventDate,
    required this.daysUntilFirstEvent,
    required this.overallProgress,
    required this.healthScore,
    required this.alerts,
  });

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsOverviewToJson(this);

  @override
  List<Object?> get props => [
        weddingId,
        weddingTitle,
        planningStartDate,
        firstEventDate,
        daysUntilFirstEvent,
        overallProgress,
        healthScore,
        alerts,
      ];
}

@JsonSerializable()
class AnalyticsAlert extends Equatable {
  final String type; // warning, info, critical
  final String category;
  final String message;
  final String action;
  final int priority;

  const AnalyticsAlert({
    required this.type,
    required this.category,
    required this.message,
    required this.action,
    required this.priority,
  });

  factory AnalyticsAlert.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsAlertFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsAlertToJson(this);

  @override
  List<Object?> get props => [type, category, message, action, priority];
}

/// Guest Analytics
@JsonSerializable()
class GuestAnalytics extends Equatable {
  final GuestSummary summary;
  final GuestBySide bySide;
  final List<GuestByEvent> byEvent;
  final GuestPredictions? predictions;

  const GuestAnalytics({
    required this.summary,
    required this.bySide,
    required this.byEvent,
    this.predictions,
  });

  factory GuestAnalytics.fromJson(Map<String, dynamic> json) =>
      _$GuestAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$GuestAnalyticsToJson(this);

  @override
  List<Object?> get props => [summary, bySide, byEvent, predictions];
}

@JsonSerializable()
class GuestSummary extends Equatable {
  final int totalInvited;
  final int confirmed;
  final int declined;
  final int pending;
  final double confirmationRate;

  const GuestSummary({
    required this.totalInvited,
    required this.confirmed,
    required this.declined,
    required this.pending,
    required this.confirmationRate,
  });

  factory GuestSummary.fromJson(Map<String, dynamic> json) =>
      _$GuestSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$GuestSummaryToJson(this);

  @override
  List<Object?> get props =>
      [totalInvited, confirmed, declined, pending, confirmationRate];
}

@JsonSerializable()
class GuestBySide extends Equatable {
  final SideStats bride;
  final SideStats groom;

  const GuestBySide({
    required this.bride,
    required this.groom,
  });

  factory GuestBySide.fromJson(Map<String, dynamic> json) =>
      _$GuestBySideFromJson(json);

  Map<String, dynamic> toJson() => _$GuestBySideToJson(this);

  @override
  List<Object?> get props => [bride, groom];
}

@JsonSerializable()
class SideStats extends Equatable {
  final int invited;
  final int confirmed;
  final double rate;

  const SideStats({
    required this.invited,
    required this.confirmed,
    required this.rate,
  });

  factory SideStats.fromJson(Map<String, dynamic> json) =>
      _$SideStatsFromJson(json);

  Map<String, dynamic> toJson() => _$SideStatsToJson(this);

  @override
  List<Object?> get props => [invited, confirmed, rate];
}

@JsonSerializable()
class GuestByEvent extends Equatable {
  final String eventId;
  final String eventName;
  final int invited;
  final int confirmed;
  final double rate;

  const GuestByEvent({
    required this.eventId,
    required this.eventName,
    required this.invited,
    required this.confirmed,
    required this.rate,
  });

  factory GuestByEvent.fromJson(Map<String, dynamic> json) =>
      _$GuestByEventFromJson(json);

  Map<String, dynamic> toJson() => _$GuestByEventToJson(this);

  @override
  List<Object?> get props => [eventId, eventName, invited, confirmed, rate];
}

@JsonSerializable()
class GuestPredictions extends Equatable {
  final int expectedFinalAttendance;
  final double confidence;

  const GuestPredictions({
    required this.expectedFinalAttendance,
    required this.confidence,
  });

  factory GuestPredictions.fromJson(Map<String, dynamic> json) =>
      _$GuestPredictionsFromJson(json);

  Map<String, dynamic> toJson() => _$GuestPredictionsToJson(this);

  @override
  List<Object?> get props => [expectedFinalAttendance, confidence];
}

/// Budget Analytics
@JsonSerializable()
class BudgetAnalytics extends Equatable {
  final BudgetSummary summary;
  final List<BudgetByCategory> byCategory;
  final BudgetForecast? forecast;

  const BudgetAnalytics({
    required this.summary,
    required this.byCategory,
    this.forecast,
  });

  factory BudgetAnalytics.fromJson(Map<String, dynamic> json) =>
      _$BudgetAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetAnalyticsToJson(this);

  @override
  List<Object?> get props => [summary, byCategory, forecast];
}

@JsonSerializable()
class BudgetSummary extends Equatable {
  final double totalBudget;
  final double spent;
  final double committed;
  final double remaining;
  final double percentSpent;

  const BudgetSummary({
    required this.totalBudget,
    required this.spent,
    required this.committed,
    required this.remaining,
    required this.percentSpent,
  });

  factory BudgetSummary.fromJson(Map<String, dynamic> json) =>
      _$BudgetSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetSummaryToJson(this);

  @override
  List<Object?> get props =>
      [totalBudget, spent, committed, remaining, percentSpent];
}

@JsonSerializable()
class BudgetByCategory extends Equatable {
  final String category;
  final String categoryName;
  final double budgeted;
  final double spent;
  final double committed;
  final double remaining;
  final double percentUsed;
  final String status; // on_budget, over_budget, under_budget

  const BudgetByCategory({
    required this.category,
    required this.categoryName,
    required this.budgeted,
    required this.spent,
    required this.committed,
    required this.remaining,
    required this.percentUsed,
    required this.status,
  });

  factory BudgetByCategory.fromJson(Map<String, dynamic> json) =>
      _$BudgetByCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetByCategoryToJson(this);

  @override
  List<Object?> get props => [
        category,
        categoryName,
        budgeted,
        spent,
        committed,
        remaining,
        percentUsed,
        status,
      ];
}

@JsonSerializable()
class BudgetForecast extends Equatable {
  final double projectedFinalCost;
  final double underOverBudget;
  final double confidence;

  const BudgetForecast({
    required this.projectedFinalCost,
    required this.underOverBudget,
    required this.confidence,
  });

  factory BudgetForecast.fromJson(Map<String, dynamic> json) =>
      _$BudgetForecastFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetForecastToJson(this);

  @override
  List<Object?> get props => [projectedFinalCost, underOverBudget, confidence];
}

/// Vendor Analytics
@JsonSerializable()
class VendorAnalytics extends Equatable {
  final VendorSummary summary;
  final List<VendorByCategory> byCategory;

  const VendorAnalytics({
    required this.summary,
    required this.byCategory,
  });

  factory VendorAnalytics.fromJson(Map<String, dynamic> json) =>
      _$VendorAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$VendorAnalyticsToJson(this);

  @override
  List<Object?> get props => [summary, byCategory];
}

@JsonSerializable()
class VendorSummary extends Equatable {
  final int vendorsContacted;
  final int quotesReceived;
  final int vendorsBooked;
  final int pendingDecisions;

  const VendorSummary({
    required this.vendorsContacted,
    required this.quotesReceived,
    required this.vendorsBooked,
    required this.pendingDecisions,
  });

  factory VendorSummary.fromJson(Map<String, dynamic> json) =>
      _$VendorSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$VendorSummaryToJson(this);

  @override
  List<Object?> get props =>
      [vendorsContacted, quotesReceived, vendorsBooked, pendingDecisions];
}

@JsonSerializable()
class VendorByCategory extends Equatable {
  final String category;
  final int contacted;
  final int quotes;
  final int booked;
  final double? averageQuote;
  final double? yourBooking;
  final double? savingsVsAverage;

  const VendorByCategory({
    required this.category,
    required this.contacted,
    required this.quotes,
    required this.booked,
    this.averageQuote,
    this.yourBooking,
    this.savingsVsAverage,
  });

  factory VendorByCategory.fromJson(Map<String, dynamic> json) =>
      _$VendorByCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$VendorByCategoryToJson(this);

  @override
  List<Object?> get props => [
        category,
        contacted,
        quotes,
        booked,
        averageQuote,
        yourBooking,
        savingsVsAverage,
      ];
}

/// Task Analytics
@JsonSerializable()
class TaskAnalytics extends Equatable {
  final TaskSummary summary;
  final List<CriticalTask> criticalPath;

  const TaskAnalytics({
    required this.summary,
    required this.criticalPath,
  });

  factory TaskAnalytics.fromJson(Map<String, dynamic> json) =>
      _$TaskAnalyticsFromJson(json);

  Map<String, dynamic> toJson() => _$TaskAnalyticsToJson(this);

  @override
  List<Object?> get props => [summary, criticalPath];
}

@JsonSerializable()
class TaskSummary extends Equatable {
  final int totalTasks;
  final int completed;
  final int inProgress;
  final int notStarted;
  final int overdue;
  final double completionRate;

  const TaskSummary({
    required this.totalTasks,
    required this.completed,
    required this.inProgress,
    required this.notStarted,
    required this.overdue,
    required this.completionRate,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskSummaryToJson(this);

  @override
  List<Object?> get props =>
      [totalTasks, completed, inProgress, notStarted, overdue, completionRate];
}

@JsonSerializable()
class CriticalTask extends Equatable {
  final String taskId;
  final String task;
  final String dueDate;
  final int daysRemaining;
  final List<String> blocking;
  final String priority;

  const CriticalTask({
    required this.taskId,
    required this.task,
    required this.dueDate,
    required this.daysRemaining,
    required this.blocking,
    required this.priority,
  });

  factory CriticalTask.fromJson(Map<String, dynamic> json) =>
      _$CriticalTaskFromJson(json);

  Map<String, dynamic> toJson() => _$CriticalTaskToJson(this);

  @override
  List<Object?> get props =>
      [taskId, task, dueDate, daysRemaining, blocking, priority];
}
