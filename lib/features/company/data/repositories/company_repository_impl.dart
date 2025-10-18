import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_local_datasource.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_with_service_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyLocalDatasource _companyLocalDatasource;

  CompanyRepositoryImpl(this._companyLocalDatasource);

  @override
  Future<Either<Failure, List<CompanyEntity>>> getCompanies() {
    return safeCall(() async {
      final payload = await _companyLocalDatasource.getCompanies();
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, CompanyWithServiceEntity>> getCompanyById(String id) {
    return safeCall(() async {
      final payload = await _companyLocalDatasource.getCompanyById(id);
      return payload.data!;
    });
  }
}
