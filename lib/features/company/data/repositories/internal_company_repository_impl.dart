import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';

class InternalCompanyRepositoryImpl implements InternalCompanyRepository {
  final CompanyManagementRemoteDatasource _companyManagementRemoteDatasource;

  InternalCompanyRepositoryImpl(this._companyManagementRemoteDatasource);

  // TODO : add cache here

  @override
  Future<Either<Failure, CompanyEntity>> getCompanyInformation() async {
    return safeCall(() async {
      final payload =
          await _companyManagementRemoteDatasource.getCompanyInformation();
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, CompanyEntity>> updateCompanyInformation(
      CompanyEntity companyEntity) {
    return safeCall(() async {
      final payload = await _companyManagementRemoteDatasource
          .updateCompanyInformation(CompanyModel.fromEntity(companyEntity));
      return payload.data!;
    });
  }
}
