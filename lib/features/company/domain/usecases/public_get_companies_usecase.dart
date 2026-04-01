import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/public_companies_repository.dart';

class PublicGetCompaniesUsecase {
  final PublicCompaniesRepository _companyRepository;

  PublicGetCompaniesUsecase(this._companyRepository);

  Future<Either<Failure, List<CompanyEntity>>> call() async {
    return _companyRepository.getCompanies();
  }
}
