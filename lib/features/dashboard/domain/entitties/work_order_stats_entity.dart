import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class WorkOrderStatsEntity extends Equatable {
  final double totalCount;
  final double draftedCount;
  final double sentCount;
  final double approvedCount;
  final double rejectedCount;
  final double onProgressCount;
  final double completedCount;
  final double cancelledCount;
  final double failedCount;

  const WorkOrderStatsEntity({
    required this.totalCount,
    required this.draftedCount,
    required this.sentCount,
    required this.approvedCount,
    required this.rejectedCount,
    required this.onProgressCount,
    required this.completedCount,
    required this.cancelledCount,
    required this.failedCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        draftedCount,
        sentCount,
        approvedCount,
        rejectedCount,
        onProgressCount,
        completedCount,
        cancelledCount,
        failedCount,
      ];

  double countByStatus(WorkOrderStatus status) {
    return switch (status) {
      WorkOrderStatus.drafted => draftedCount,
      WorkOrderStatus.sent => sentCount,
      WorkOrderStatus.cancelled => cancelledCount,
      WorkOrderStatus.rejected => rejectedCount,
      WorkOrderStatus.approved => approvedCount,
      WorkOrderStatus.onProgress => onProgressCount,
      WorkOrderStatus.completed => completedCount,
      WorkOrderStatus.failed => failedCount,
    };
  }
}
