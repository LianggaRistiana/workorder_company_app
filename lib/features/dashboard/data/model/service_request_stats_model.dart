import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/service_request_stats_entity.dart';

class ServiceRequestStatsModel extends ServiceRequestStatsEntity {
  const ServiceRequestStatsModel({
    required super.totalCount,
    required super.receivedCount,
    required super.cancelledCount,
    required super.rejectedCount,
    required super.approvedCount,
    required super.onProgressCount,
    required super.unProcessableCount,
    required super.completedCount,
    required super.partiallyCompletedCount,
    required super.closedCount,
  });

  factory ServiceRequestStatsModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestStatsModel(
      totalCount: json.field('total_count').reqInt().toDouble(),
      receivedCount: json.field('status_count.received').reqInt().toDouble(),
      cancelledCount: json.field('status_count.cancelled').reqInt().toDouble(),
      rejectedCount: json.field('status_count.rejected').reqInt().toDouble(),
      approvedCount: json.field('status_count.approved').reqInt().toDouble(),
      onProgressCount:
          json.field('status_count.on_progress').reqInt().toDouble(),
      unProcessableCount:
          json.field('status_count.unprocessable').reqInt().toDouble(),
      completedCount: json.field('status_count.completed').reqInt().toDouble(),
      partiallyCompletedCount:
          json.field('status_count.partial_completed').reqInt().toDouble(),
      closedCount: json.field('status_count.closed').reqInt().toDouble(),
    );
  }
}
