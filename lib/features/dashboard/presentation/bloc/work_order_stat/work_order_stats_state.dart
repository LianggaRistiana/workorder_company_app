import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/work_order_stats_entity.dart';

enum WorkOrderStatsStatus {
  initial,
  loading,
  success,
  error,
}

class WorkOrderStatsState {
  final WorkOrderStatsStatus status;
  final WorkOrderStatsEntity? stats;
  final PeriodType periodType;
  final String? errorMessage;

  const WorkOrderStatsState({
    this.status = WorkOrderStatsStatus.initial,
    this.periodType = PeriodType.currentDay,
    this.stats,
    this.errorMessage,
  });

  WorkOrderStatsState copyWith({
    WorkOrderStatsStatus? status,
    WorkOrderStatsEntity? stats,
    PeriodType? periodType,
    String? errorMessage,
  }) {
    return WorkOrderStatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      periodType: periodType ?? this.periodType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
