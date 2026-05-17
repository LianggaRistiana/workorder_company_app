import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/customer_account_integration_repository.dart';

class GetAllPairedAccountUsecase {
  final CustomerAccountIntegrationRepository repository;

  GetAllPairedAccountUsecase(this.repository);

  FutureEitherList<ExternalUserEntity> call() {
    return repository.getAllAccountsPairingStatus();
  }
}
