import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDatasource _companyRemoteDatasource;
  final CompanyManagementRemoteDatasource _companyManagementRemoteDatasource;

  CompanyRepositoryImpl(
      this._companyRemoteDatasource, this._companyManagementRemoteDatasource);

  @override
  Future<Either<Failure, List<CompanyEntity>>> getCompanies() {
    return safeCall(() async {
      final payload = await _companyRemoteDatasource.getCompanies();
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, CompanyEntity>> getCompanyById(String id) {
    return safeCall(() async {
      final payload = await _companyRemoteDatasource.getCompanyById(id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getCompanyService(String id) {
    return safeCall(() async {
      final payload = await _companyRemoteDatasource.getCompanyService(id);
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, CompanyEntity>> getCompanyInformation() async {
    return safeCall(() async {
      final payload =
          await _companyManagementRemoteDatasource.getCompanyInformation();
      return payload.data!;
    });
    // return Left(AuthFailure(message: "tyest error"));
    // return Right(
    //   CompanyEntity(
    //     id: "mock-company-id",
    //     name: "Telkomsel",
    //     isActive: false,
    //   ),
    // );
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
