import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/company_stats_entity.dart';
import 'package:workorder_company_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetCompanyStatsUsecase {
  final DashboardRepository _repository;

  GetCompanyStatsUsecase(this._repository);

  FutureEither<CompanyStatsEntity> call() {
    return _repository.getCompanyStats();
  }
}
