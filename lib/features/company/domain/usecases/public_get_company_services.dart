import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';

class PublicGetCompanyServicesUsecase {
  final CompanyRepository _companyRepository;

  PublicGetCompanyServicesUsecase(this._companyRepository);

  Future<Either<Failure, List<ServiceEntity>>> call(String id) async {
    return _companyRepository.getCompanyService(id);
  }
}