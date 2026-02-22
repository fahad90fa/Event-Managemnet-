// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeddingAnalyticsDashboard _$WeddingAnalyticsDashboardFromJson(
        Map<String, dynamic> json) =>
    WeddingAnalyticsDashboard(
      overview:
          AnalyticsOverview.fromJson(json['overview'] as Map<String, dynamic>),
      guestAnalytics: GuestAnalytics.fromJson(
          json['guestAnalytics'] as Map<String, dynamic>),
      budgetAnalytics: BudgetAnalytics.fromJson(
          json['budgetAnalytics'] as Map<String, dynamic>),
      vendorAnalytics: VendorAnalytics.fromJson(
          json['vendorAnalytics'] as Map<String, dynamic>),
      taskAnalytics:
          TaskAnalytics.fromJson(json['taskAnalytics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeddingAnalyticsDashboardToJson(
        WeddingAnalyticsDashboard instance) =>
    <String, dynamic>{
      'overview': instance.overview,
      'guestAnalytics': instance.guestAnalytics,
      'budgetAnalytics': instance.budgetAnalytics,
      'vendorAnalytics': instance.vendorAnalytics,
      'taskAnalytics': instance.taskAnalytics,
    };

AnalyticsOverview _$AnalyticsOverviewFromJson(Map<String, dynamic> json) =>
    AnalyticsOverview(
      weddingId: json['weddingId'] as String,
      weddingTitle: json['weddingTitle'] as String,
      planningStartDate: json['planningStartDate'] as String,
      firstEventDate: json['firstEventDate'] as String,
      daysUntilFirstEvent: (json['daysUntilFirstEvent'] as num).toInt(),
      overallProgress: (json['overallProgress'] as num).toDouble(),
      healthScore: (json['healthScore'] as num).toInt(),
      alerts: (json['alerts'] as List<dynamic>)
          .map((e) => AnalyticsAlert.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyticsOverviewToJson(AnalyticsOverview instance) =>
    <String, dynamic>{
      'weddingId': instance.weddingId,
      'weddingTitle': instance.weddingTitle,
      'planningStartDate': instance.planningStartDate,
      'firstEventDate': instance.firstEventDate,
      'daysUntilFirstEvent': instance.daysUntilFirstEvent,
      'overallProgress': instance.overallProgress,
      'healthScore': instance.healthScore,
      'alerts': instance.alerts,
    };

AnalyticsAlert _$AnalyticsAlertFromJson(Map<String, dynamic> json) =>
    AnalyticsAlert(
      type: json['type'] as String,
      category: json['category'] as String,
      message: json['message'] as String,
      action: json['action'] as String,
      priority: (json['priority'] as num).toInt(),
    );

Map<String, dynamic> _$AnalyticsAlertToJson(AnalyticsAlert instance) =>
    <String, dynamic>{
      'type': instance.type,
      'category': instance.category,
      'message': instance.message,
      'action': instance.action,
      'priority': instance.priority,
    };

GuestAnalytics _$GuestAnalyticsFromJson(Map<String, dynamic> json) =>
    GuestAnalytics(
      summary: GuestSummary.fromJson(json['summary'] as Map<String, dynamic>),
      bySide: GuestBySide.fromJson(json['bySide'] as Map<String, dynamic>),
      byEvent: (json['byEvent'] as List<dynamic>)
          .map((e) => GuestByEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      predictions: json['predictions'] == null
          ? null
          : GuestPredictions.fromJson(
              json['predictions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GuestAnalyticsToJson(GuestAnalytics instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'bySide': instance.bySide,
      'byEvent': instance.byEvent,
      'predictions': instance.predictions,
    };

GuestSummary _$GuestSummaryFromJson(Map<String, dynamic> json) => GuestSummary(
      totalInvited: (json['totalInvited'] as num).toInt(),
      confirmed: (json['confirmed'] as num).toInt(),
      declined: (json['declined'] as num).toInt(),
      pending: (json['pending'] as num).toInt(),
      confirmationRate: (json['confirmationRate'] as num).toDouble(),
    );

Map<String, dynamic> _$GuestSummaryToJson(GuestSummary instance) =>
    <String, dynamic>{
      'totalInvited': instance.totalInvited,
      'confirmed': instance.confirmed,
      'declined': instance.declined,
      'pending': instance.pending,
      'confirmationRate': instance.confirmationRate,
    };

GuestBySide _$GuestBySideFromJson(Map<String, dynamic> json) => GuestBySide(
      bride: SideStats.fromJson(json['bride'] as Map<String, dynamic>),
      groom: SideStats.fromJson(json['groom'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GuestBySideToJson(GuestBySide instance) =>
    <String, dynamic>{
      'bride': instance.bride,
      'groom': instance.groom,
    };

SideStats _$SideStatsFromJson(Map<String, dynamic> json) => SideStats(
      invited: (json['invited'] as num).toInt(),
      confirmed: (json['confirmed'] as num).toInt(),
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$SideStatsToJson(SideStats instance) => <String, dynamic>{
      'invited': instance.invited,
      'confirmed': instance.confirmed,
      'rate': instance.rate,
    };

GuestByEvent _$GuestByEventFromJson(Map<String, dynamic> json) => GuestByEvent(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      invited: (json['invited'] as num).toInt(),
      confirmed: (json['confirmed'] as num).toInt(),
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$GuestByEventToJson(GuestByEvent instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'eventName': instance.eventName,
      'invited': instance.invited,
      'confirmed': instance.confirmed,
      'rate': instance.rate,
    };

GuestPredictions _$GuestPredictionsFromJson(Map<String, dynamic> json) =>
    GuestPredictions(
      expectedFinalAttendance: (json['expectedFinalAttendance'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$GuestPredictionsToJson(GuestPredictions instance) =>
    <String, dynamic>{
      'expectedFinalAttendance': instance.expectedFinalAttendance,
      'confidence': instance.confidence,
    };

BudgetAnalytics _$BudgetAnalyticsFromJson(Map<String, dynamic> json) =>
    BudgetAnalytics(
      summary: BudgetSummary.fromJson(json['summary'] as Map<String, dynamic>),
      byCategory: (json['byCategory'] as List<dynamic>)
          .map((e) => BudgetByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      forecast: json['forecast'] == null
          ? null
          : BudgetForecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BudgetAnalyticsToJson(BudgetAnalytics instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'byCategory': instance.byCategory,
      'forecast': instance.forecast,
    };

BudgetSummary _$BudgetSummaryFromJson(Map<String, dynamic> json) =>
    BudgetSummary(
      totalBudget: (json['totalBudget'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      committed: (json['committed'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percentSpent: (json['percentSpent'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetSummaryToJson(BudgetSummary instance) =>
    <String, dynamic>{
      'totalBudget': instance.totalBudget,
      'spent': instance.spent,
      'committed': instance.committed,
      'remaining': instance.remaining,
      'percentSpent': instance.percentSpent,
    };

BudgetByCategory _$BudgetByCategoryFromJson(Map<String, dynamic> json) =>
    BudgetByCategory(
      category: json['category'] as String,
      categoryName: json['categoryName'] as String,
      budgeted: (json['budgeted'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      committed: (json['committed'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      percentUsed: (json['percentUsed'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$BudgetByCategoryToJson(BudgetByCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
      'categoryName': instance.categoryName,
      'budgeted': instance.budgeted,
      'spent': instance.spent,
      'committed': instance.committed,
      'remaining': instance.remaining,
      'percentUsed': instance.percentUsed,
      'status': instance.status,
    };

BudgetForecast _$BudgetForecastFromJson(Map<String, dynamic> json) =>
    BudgetForecast(
      projectedFinalCost: (json['projectedFinalCost'] as num).toDouble(),
      underOverBudget: (json['underOverBudget'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$BudgetForecastToJson(BudgetForecast instance) =>
    <String, dynamic>{
      'projectedFinalCost': instance.projectedFinalCost,
      'underOverBudget': instance.underOverBudget,
      'confidence': instance.confidence,
    };

VendorAnalytics _$VendorAnalyticsFromJson(Map<String, dynamic> json) =>
    VendorAnalytics(
      summary: VendorSummary.fromJson(json['summary'] as Map<String, dynamic>),
      byCategory: (json['byCategory'] as List<dynamic>)
          .map((e) => VendorByCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VendorAnalyticsToJson(VendorAnalytics instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'byCategory': instance.byCategory,
    };

VendorSummary _$VendorSummaryFromJson(Map<String, dynamic> json) =>
    VendorSummary(
      vendorsContacted: (json['vendorsContacted'] as num).toInt(),
      quotesReceived: (json['quotesReceived'] as num).toInt(),
      vendorsBooked: (json['vendorsBooked'] as num).toInt(),
      pendingDecisions: (json['pendingDecisions'] as num).toInt(),
    );

Map<String, dynamic> _$VendorSummaryToJson(VendorSummary instance) =>
    <String, dynamic>{
      'vendorsContacted': instance.vendorsContacted,
      'quotesReceived': instance.quotesReceived,
      'vendorsBooked': instance.vendorsBooked,
      'pendingDecisions': instance.pendingDecisions,
    };

VendorByCategory _$VendorByCategoryFromJson(Map<String, dynamic> json) =>
    VendorByCategory(
      category: json['category'] as String,
      contacted: (json['contacted'] as num).toInt(),
      quotes: (json['quotes'] as num).toInt(),
      booked: (json['booked'] as num).toInt(),
      averageQuote: (json['averageQuote'] as num?)?.toDouble(),
      yourBooking: (json['yourBooking'] as num?)?.toDouble(),
      savingsVsAverage: (json['savingsVsAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VendorByCategoryToJson(VendorByCategory instance) =>
    <String, dynamic>{
      'category': instance.category,
      'contacted': instance.contacted,
      'quotes': instance.quotes,
      'booked': instance.booked,
      'averageQuote': instance.averageQuote,
      'yourBooking': instance.yourBooking,
      'savingsVsAverage': instance.savingsVsAverage,
    };

TaskAnalytics _$TaskAnalyticsFromJson(Map<String, dynamic> json) =>
    TaskAnalytics(
      summary: TaskSummary.fromJson(json['summary'] as Map<String, dynamic>),
      criticalPath: (json['criticalPath'] as List<dynamic>)
          .map((e) => CriticalTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskAnalyticsToJson(TaskAnalytics instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'criticalPath': instance.criticalPath,
    };

TaskSummary _$TaskSummaryFromJson(Map<String, dynamic> json) => TaskSummary(
      totalTasks: (json['totalTasks'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      inProgress: (json['inProgress'] as num).toInt(),
      notStarted: (json['notStarted'] as num).toInt(),
      overdue: (json['overdue'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$TaskSummaryToJson(TaskSummary instance) =>
    <String, dynamic>{
      'totalTasks': instance.totalTasks,
      'completed': instance.completed,
      'inProgress': instance.inProgress,
      'notStarted': instance.notStarted,
      'overdue': instance.overdue,
      'completionRate': instance.completionRate,
    };

CriticalTask _$CriticalTaskFromJson(Map<String, dynamic> json) => CriticalTask(
      taskId: json['taskId'] as String,
      task: json['task'] as String,
      dueDate: json['dueDate'] as String,
      daysRemaining: (json['daysRemaining'] as num).toInt(),
      blocking:
          (json['blocking'] as List<dynamic>).map((e) => e as String).toList(),
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$CriticalTaskToJson(CriticalTask instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'task': instance.task,
      'dueDate': instance.dueDate,
      'daysRemaining': instance.daysRemaining,
      'blocking': instance.blocking,
      'priority': instance.priority,
    };
