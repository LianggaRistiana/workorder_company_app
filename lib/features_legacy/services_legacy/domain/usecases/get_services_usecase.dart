import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/repositories/service_repository.dart';

class GetServicesUsecase {
  final ServiceRepository _repository;

  GetServicesUsecase(this._repository);

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return _repository.getServices();
  }
}
