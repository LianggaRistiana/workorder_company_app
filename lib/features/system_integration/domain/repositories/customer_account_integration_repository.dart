import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/start_pairing_data_entity.dart';

abstract class CustomerAccountIntegrationRepository {
  FutureEither<StartPairingDataEntity> startPairing(
    String companyId,
  );
  FutureEither<ExternalUserEntity> completePairing({
    required String companyId,
    required String code,
    required String state,
  });
  FutureEither<ExternalUserEntity> getAccountPairingStatus(String companyId);
  FutureEither<ExternalUserEntity> detachAccountPairing(String companyId);
  FutureEitherList<ExternalUserEntity> getAllAccountsPairingStatus();
}
