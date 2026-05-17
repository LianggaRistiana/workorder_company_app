import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/customer_account_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/start_pairing_data_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/customer_account_integration_repository.dart';

class CustomerAccountIntegrationRepositoryImpl
    implements CustomerAccountIntegrationRepository {
  final CustomerAccountIntegrationRemoteDatasource _remoteDatasource;

  CustomerAccountIntegrationRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<ExternalUserEntity> completePairing(
      {required String companyId,
      required String code,
      required String state}) {
    return safeCall(() async {
      final response = await _remoteDatasource.completePairing(
        companyId: companyId,
        code: code,
        state: state,
      );
      return response.data;
    });
  }

  @override
  FutureEither<ExternalUserEntity> detachAccountPairing(String companyId) {
    return safeCall(() async {
      final response = await _remoteDatasource.detachAccountPairing(companyId);
      return response.data;
    });
  }

  @override
  FutureEither<ExternalUserEntity> getAccountPairingStatus(String companyId) {
    return safeCall(() async {
      final response =
          await _remoteDatasource.getAccountPairingStatus(companyId);
      return response.data;
    });
  }

  @override
  FutureEitherList<ExternalUserEntity> getAllAccountsPairingStatus() {
    return safeCall(() async {
      final response = await _remoteDatasource.getAllAccountsPairingStatus();
      return response.data;
    });
  }

  @override
  FutureEither<StartPairingDataEntity> startPairing(String companyId) {
    return safeCall(() async {
      final response = await _remoteDatasource.startPairing(companyId);
      return response.data;
    });
  }
}
