import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/provider_integration_repository.dart';

class GetProviderIntegrationUsecase {
  final ProviderIntegrationRepository _repository;

  GetProviderIntegrationUsecase(this._repository);

  FutureEither<ProviderIntegrationDataEntity> call() async {
    return await _repository.getProviderIntegrationData();
  }
}
