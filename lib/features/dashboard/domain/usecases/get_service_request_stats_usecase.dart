import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/service_request_stats_entity.dart';
import 'package:workorder_company_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetServiceRequestStatsUsecase {
  final DashboardRepository repository;

  GetServiceRequestStatsUsecase(this.repository);

  FutureEither<ServiceRequestStatsEntity> call(PeriodType periodType) async {
    return await repository.getServiceRequestStats(
      periodType,
    );
  }
}
