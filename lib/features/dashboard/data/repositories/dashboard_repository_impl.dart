import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/service_request_stats_entity.dart';
import 'package:workorder_company_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource _remoteDatasource;

  DashboardRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<ServiceRequestStatsEntity> getServiceRequestStats(
    PeriodType periodType,
  ) {
    return safeCall(() async {
      final response = await _remoteDatasource.getServiceRequestStats(
        periodType,
      );
      return response.data;
    });
  }
}
