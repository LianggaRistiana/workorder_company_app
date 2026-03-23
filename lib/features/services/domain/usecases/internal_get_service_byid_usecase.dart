import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class InternalGetServiceByidUsecase {
  final ServicesRepository _repository;

  InternalGetServiceByidUsecase(this._repository);

  FutureEither<ServiceEntity> call(String id) async {
    return await _repository.getServiceById(id);
  }
}
