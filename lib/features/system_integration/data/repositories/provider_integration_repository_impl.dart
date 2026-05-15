import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/provider_integration_repository.dart';

class ProviderIntegrationRepositoryImpl
    implements ProviderIntegrationRepository {
  final ProviderIntegrationRemoteDatasource _remoteDatasource;

  ProviderIntegrationRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<ProviderIntegrationDataEntity>
      getProviderIntegrationData() async {
    return safeCall(() async {
      final result = await _remoteDatasource.getProviderIntegrationData();
      return result.data;
    });
  }

  @override
  FutureEither<ProviderIntegrationDataEntity> updateProviderIntegrationData(
    ProviderIntegrationDataEntity providerIntegrationData,
  ) async {
    return safeCall(() async {
      final result = await _remoteDatasource.updateProviderIntegrationData(
        ProviderIntegrationDataModel.fromEntity(providerIntegrationData),
      );
      return result.data;
    });
  }
}
