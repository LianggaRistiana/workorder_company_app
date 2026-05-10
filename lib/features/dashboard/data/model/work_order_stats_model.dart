import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/work_order_stats_entity.dart';

class WorkOrderStatsModel extends WorkOrderStatsEntity {
  const WorkOrderStatsModel({
    required super.totalCount,
    required super.draftedCount,
    required super.sentCount,
    required super.approvedCount,
    required super.rejectedCount,
    required super.onProgressCount,
    required super.completedCount,
    required super.cancelledCount,
    required super.failedCount,
  });

  factory WorkOrderStatsModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderStatsModel(
      totalCount: json.field("total_count").reqInt().toDouble(),
      draftedCount: json.field("status_count.drafted").reqInt().toDouble(),
      sentCount: json.field("status_count.sent").reqInt().toDouble(),
      approvedCount: json.field("status_count.approved").reqInt().toDouble(),
      rejectedCount: json.field("status_count.rejected").reqInt().toDouble(),
      onProgressCount:
          json.field("status_count.on_progress").reqInt().toDouble(),
      completedCount: json.field("status_count.completed").reqInt().toDouble(),
      cancelledCount: json.field("status_count.cancelled").reqInt().toDouble(),
      failedCount: json.field("status_count.failed").reqInt().toDouble(),
    );
  }
}
