import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/services/data/models/service_model.dart';

abstract class ServiceRemoteDatasource {
  Future<ApiResponse<List<ServiceModel>>> getServices();
  Future<ApiResponse<ServiceModel>> getService(String id);
}

class ServiceRemoteDatasourceImpl implements ServiceRemoteDatasource {
  final ApiClient _apiClient;

  ServiceRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<ServiceModel>> getService(String id) {
    // TODO: implement getService
    throw UnimplementedError();
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
}
