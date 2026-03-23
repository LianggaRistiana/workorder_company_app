

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services_legacy/domain/repositories/service_repository.dart';

class CreateServiceUsecase {
  final ServiceRepository _repository;

  CreateServiceUsecase(this._repository);

  Future<Either<Failure, void>> call(ServiceEntity service) async {
    return _repository.createService(service);
  }
}