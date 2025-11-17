import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/client_service_request/data/model/client_service_request_model.dart';

abstract class ClientServiceRequestRemoteDatasource {
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      publicGetClientServiceRequests();
  Future<ApiResponse<ClientServiceRequestModel>>
      publicGetClientServiceRequestById(String id);
}

class ClientServiceRequestRemoteDatasourceImpl
    implements ClientServiceRequestRemoteDatasource {
  final ApiClient _apiClient;

  ClientServiceRequestRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<ClientServiceRequestModel>>
      publicGetClientServiceRequestById(String id) {
    // TODO: implement publicGetClientServiceRequestById
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      publicGetClientServiceRequests() async {
    final response = await _apiClient.get(Endpoints.publicClientServiceRequest);
    // return ApiResponse.fromJson(
    //     response,
    //     (data) => (data as List<dynamic>? ?? [])
    //         .map((e) =>
    //             ClientServiceRequestModel.fromJson(e as Map<String, dynamic>))
    //         .toList());
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data as List?,
        (json) => ClientServiceRequestModel.fromJson(json),
      ),
    );
  }
}
