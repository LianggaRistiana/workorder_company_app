import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/public_companies_repository.dart';

class PublicGetCompanyDetailUsecase {
  final PublicCompaniesRepository _companyRepository;

  PublicGetCompanyDetailUsecase(this._companyRepository);

  Future<Either<Failure, CompanyEntity>> call(String id) async {
    return _companyRepository.getCompanyById(id);
  }
}
