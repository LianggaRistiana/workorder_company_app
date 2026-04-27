import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

abstract class InternalCompanyRepository implements Cacheable {
  FutureEither<CompanyEntity> getCompanyInformation({
    bool forceRefresh = false,
  });
  FutureEither<CompanyEntity> updateCompanyInformation(
      CompanyEntity companyEntity);
}
