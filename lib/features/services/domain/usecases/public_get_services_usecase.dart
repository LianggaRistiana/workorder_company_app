import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class PublicGetServicesUsecase {
  final ServicesRepository _repository;

  PublicGetServicesUsecase(this._repository);

  FutureEitherList<ServiceSummaryEntity> call(String companyId) {
    return _repository.getPublicServices(companyId);
  }
}
