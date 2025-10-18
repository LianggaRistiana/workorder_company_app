import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_with_service_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';

class GetCompanyWithService {
  final CompanyRepository _companyRepository;

  GetCompanyWithService(this._companyRepository);

  Future<Either<Failure, CompanyWithServiceEntity>> call(String id) async {
    return _companyRepository.getCompanyById(id);
  }
}
