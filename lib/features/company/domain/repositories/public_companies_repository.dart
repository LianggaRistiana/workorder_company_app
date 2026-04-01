import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

abstract class PublicCompaniesRepository {
  FutureEitherList<CompanyEntity> getCompanies();
  FutureEither<CompanyEntity> getCompanyById(String id);
}
