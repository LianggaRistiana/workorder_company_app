import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';

abstract class ProviderIntegrationRepository {
  FutureEither<ProviderIntegrationDataEntity> getProviderIntegrationData();
  FutureEither<ProviderIntegrationDataEntity> updateProviderIntegrationData(
    ProviderIntegrationDataEntity providerIntegrationData,
  );
}
