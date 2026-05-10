import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/service_request_stats_entity.dart';

abstract class DashboardRepository {
  FutureEither<ServiceRequestStatsEntity> getServiceRequestStats(
    PeriodType periodType,
  );
  // TODO :  Work order stat
  // TODO :  Company Stat
}

