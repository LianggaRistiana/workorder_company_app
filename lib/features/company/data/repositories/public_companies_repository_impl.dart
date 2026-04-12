import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/public_companies_remote_datasource.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/public_companies_repository.dart';

class PublicCompaniesRepositoryImpl implements PublicCompaniesRepository {
  final PublicCompaniesRemoteDatasource _companyRemoteDatasource;

  PublicCompaniesRepositoryImpl(this._companyRemoteDatasource);

  @override
  FutureEitherList<CompanyEntity> getCompanies() {
    return safeCall(() async {
      final payload = await _companyRemoteDatasource.getCompanies();
      return payload.data;
    });
  }

  @override
  FutureEither<CompanyEntity> getCompanyById(String id) {
    return safeCall(() async {
      final payload = await _companyRemoteDatasource.getCompanyById(id);
      return payload.data;
    });
  }
}
