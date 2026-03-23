import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/services_legacy/data/models/service_model.dart';

abstract class ServiceRemoteDatasource {
  Future<ApiResponse<List<ServiceModel>>> getServices();
  Future<ApiResponse<ServiceModel>> getService(String id);
  Future<ApiResponse<ServiceModel>> createService(ServiceModel service);
}

class ServiceRemoteDatasourceImpl implements ServiceRemoteDatasource {
  final ApiClient _apiClient;

  ServiceRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<ServiceModel>> getService(String id) async {
    final response = await _apiClient.get(Endpoints.services.byId(id));
    return ApiResponse.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }

  @override
  Future<ApiResponse<List<ServiceModel>>> getServices() async {
    final response = await _apiClient.get(Endpoints.services);

    return ApiResponse.fromJson(
      response,
      (data) => (data as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<ServiceModel>> createService(ServiceModel service) async {
    final response =
        await _apiClient.post(Endpoints.services, data: service.toJson());
    return ApiResponse<ServiceModel>.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }
}
