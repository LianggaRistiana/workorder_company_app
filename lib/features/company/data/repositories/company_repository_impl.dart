import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDatasource _companyLocalDatasource;

  CompanyRepositoryImpl(this._companyLocalDatasource);

  @override
  Future<Either<Failure, List<CompanyEntity>>> getCompanies() {
    return safeCall(() async {
      final payload = await _companyLocalDatasource.getCompanies();
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, CompanyEntity>> getCompanyById(String id) {
    return safeCall(() async {
      final payload = await _companyLocalDatasource.getCompanyById(id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getCompanyService(String id) {
    return safeCall(() async {
      final payload = await _companyLocalDatasource.getCompanyService(id);
      return payload.data ?? [];
    });
  }
}
