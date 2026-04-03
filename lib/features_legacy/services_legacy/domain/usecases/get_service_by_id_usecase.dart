import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/repositories/service_repository.dart';

class GetServiceByIdUsecase {
  final ServiceRepository _repository;

  GetServiceByIdUsecase(this._repository);

  Future<Either<Failure, ServiceEntity>> call(String id) async {
    return _repository.getService(id);
  }
}
