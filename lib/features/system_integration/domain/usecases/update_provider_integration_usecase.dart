import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/provider_integration_repository.dart';

class UpdateProviderIntegrationUsecase {
  final ProviderIntegrationRepository _repository;

  UpdateProviderIntegrationUsecase(this._repository);

  FutureEither<ProviderIntegrationDataEntity> call(
    ProviderIntegrationDataEntity providerIntegrationData,
  ) async {
    return await _repository.updateProviderIntegrationData(
      providerIntegrationData,
    );
  }
}
