import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';

abstract class ProviderIntegrationRemoteDatasource {
  ApiFuture<ProviderIntegrationDataModel> getProviderIntegrationData();
  ApiFuture<ProviderIntegrationDataModel> updateProviderIntegrationData(
    ProviderIntegrationDataModel providerIntegrationData,
  );
}

class ProviderIntegrationRemoteDatasourceImpl
    implements ProviderIntegrationRemoteDatasource {
  final ApiClient _apiClient;

  ProviderIntegrationRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ProviderIntegrationDataModel> getProviderIntegrationData() async {
    final response = await _apiClient.get(Endpoints.systemIntegration);
    return ApiResponse.fromJson(
      response,
      (json) => ProviderIntegrationDataModel.fromJson(json),
    );
  }

  @override
  ApiFuture<ProviderIntegrationDataModel> updateProviderIntegrationData(
      ProviderIntegrationDataModel providerIntegrationData) async {
    final response = await _apiClient.put(
      Endpoints.systemIntegration,
      data: providerIntegrationData.toJson(),
    );
    return ApiResponse.fromJson(
      response,
      (json) => ProviderIntegrationDataModel.fromJson(json),
    );
  }
}
