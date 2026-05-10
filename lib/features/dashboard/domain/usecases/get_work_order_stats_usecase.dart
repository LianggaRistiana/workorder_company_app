import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/work_order_stats_entity.dart';
import 'package:workorder_company_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetWorkOrderStatsUsecase {
  final DashboardRepository _repository;

  GetWorkOrderStatsUsecase(this._repository);

  FutureEither<WorkOrderStatsEntity> call(PeriodType periodType) {
    return _repository.getWorkOrderStats(periodType);
  }
}
