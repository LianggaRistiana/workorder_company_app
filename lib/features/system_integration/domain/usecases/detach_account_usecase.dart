import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/customer_account_integration_repository.dart';

class DetachAccountUsecase {
  final CustomerAccountIntegrationRepository repository;

  DetachAccountUsecase(this.repository);

  FutureEither<ExternalUserEntity> call(String companyId) {
    return repository.detachAccountPairing(companyId);
  }
}
