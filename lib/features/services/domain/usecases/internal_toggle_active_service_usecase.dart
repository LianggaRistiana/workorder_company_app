import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class InternalToggleActiveServiceUsecase {
  final ServicesRepository _repository;

  InternalToggleActiveServiceUsecase(this._repository);

  FutureEither<ServiceEntity> call(ServiceEntity service) {
    return _repository.toggleActiveStatus(service);
  }
}
