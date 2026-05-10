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
      totalCount: json.field('total_count').reqDouble(),
      receivedCount: json.field('status_count.received').reqDouble(),
      cancelledCount: json.field('status_count.cancelled').reqDouble(),
      rejectedCount: json.field('status_count.rejected').reqDouble(),
      approvedCount: json.field('status_count.approved').reqDouble(),
      onProgressCount: json.field('status_count.on_progress').reqDouble(),
      unProcessableCount: json.field('status_count.unprocessable').reqDouble(),
      completedCount: json.field('status_count.completed').reqDouble(),
      partiallyCompletedCount:
          json.field('status_count.partial_completed').reqDouble(),
      closedCount: json.field('status_count.closed').reqDouble(),
    );
  }
}
