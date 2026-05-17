import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/customer_account_integration_repository.dart';

class CompletePairingUsecase {
  final CustomerAccountIntegrationRepository repository;

  CompletePairingUsecase(this.repository);

  FutureEither<ExternalUserEntity> call({
    required String companyId,
    required String code,
    required String state,
  }) {
    return repository.completePairing(
      companyId: companyId,
      code: code,
      state: state,
    );
  }
}
