import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class InternalCreateServiceUsecase {
  final ServicesRepository _repository;

  InternalCreateServiceUsecase(this._repository);

 FutureEither<ServiceEntity>  call(ServiceEntity service) async {
    return _repository.createService(service);
  }
}
