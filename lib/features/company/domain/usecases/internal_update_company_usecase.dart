import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';

class InternalUpdateCompanyUsecase {
  final CompanyRepository _repository;

  InternalUpdateCompanyUsecase(this._repository);

  Future<Either<Failure, CompanyEntity>> call(
      CompanyEntity companyEntity) async {
    return await _repository.updateCompanyInformation(companyEntity);
  }
}
