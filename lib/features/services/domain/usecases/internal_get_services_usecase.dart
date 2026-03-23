import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class InternalGetServicesUsecase {
  final ServicesRepository _repository;

  InternalGetServicesUsecase(this._repository);

  FutureEitherList<ServiceSummaryEntity> call() async {
    return await _repository.getServices();
  }
}
