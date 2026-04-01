import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

abstract class InternalCompanyRepository {
  FutureEither<CompanyEntity> getCompanyInformation();
  FutureEither<CompanyEntity> updateCompanyInformation(
      CompanyEntity companyEntity);
}
