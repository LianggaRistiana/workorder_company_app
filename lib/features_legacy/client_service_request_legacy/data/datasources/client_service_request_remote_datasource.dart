import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/data/model/client_service_request_model.dart';
import 'package:workorder_company_app/features/workorder/data/model/workorder_model.dart';

abstract class ClientServiceRequestRemoteDatasource {
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      publicGetClientServiceRequests();
  Future<ApiResponse<ClientServiceRequestModel>>
      publicGetClientServiceRequestById(String id);
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      getClientServiceRequests();
  Future<ApiResponse<ClientServiceRequestModel>> getClientServiceRequestById(
      String id);
  Future<ApiResponse<WorkorderModel>> approveClientServiceRequest(String id);
  Future<ApiResponse<ClientServiceRequestModel>> rejectClientServiceRequest(
      String id);
  Future<ApiResponse<ClientServiceRequestModel>> cancelClientServiceRequest(
      String id);
}

class ClientServiceRequestRemoteDatasourceImpl
    implements ClientServiceRequestRemoteDatasource {
  // ignore: unused_field
  final ApiClient _apiClient;

  ClientServiceRequestRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<WorkorderModel>> approveClientServiceRequest(String id) {
    // TODO: implement approveClientServiceRequest
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<ClientServiceRequestModel>> cancelClientServiceRequest(
      String id) {
    // TODO: implement cancelClientServiceRequest
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<ClientServiceRequestModel>> getClientServiceRequestById(
      String id) {
    // TODO: implement getClientServiceRequestById
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      getClientServiceRequests() {
    // TODO: implement getClientServiceRequests
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<ClientServiceRequestModel>>
      publicGetClientServiceRequestById(String id) {
    // TODO: implement publicGetClientServiceRequestById
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<ClientServiceRequestModel>>>
      publicGetClientServiceRequests() {
    // TODO: implement publicGetClientServiceRequests
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<ClientServiceRequestModel>> rejectClientServiceRequest(
      String id) {
    // TODO: implement rejectClientServiceRequest
    throw UnimplementedError();
  }
}

// class ClientServiceRequestRemoteDatasourceImpl
//     implements ClientServiceRequestRemoteDatasource {
//   final ApiClient _apiClient;

//   ClientServiceRequestRemoteDatasourceImpl(this._apiClient);

//   @override
//   Future<ApiResponse<ClientServiceRequestModel>>
//       publicGetClientServiceRequestById(String id) async {
//     final response =
//         await _apiClient.get(Endpoints.publicClientServiceRequest.byId(id));
//     return ApiResponse.fromJson(
//         response, (json) => ClientServiceRequestModel.fromJson(json));
//   }

//   @override
//   Future<ApiResponse<List<ClientServiceRequestModel>>>
//       publicGetClientServiceRequests() async {
//     final response = await _apiClient.get(Endpoints.publicClientServiceRequest);
//     return ApiResponse.fromJson(
//       response,
//       (data) => SafeMapper.mapList(
//         data as List?,
//         (json) => ClientServiceRequestModel.fromJson(json),
//       ),
//     );
//   }

//   @override
//   Future<ApiResponse<ClientServiceRequestModel>> getClientServiceRequestById(
//       String id) async {
//     final response =
//         await _apiClient.get(Endpoints.serviceRequestDetail.fill(id));
//     return ApiResponse.fromJson(
//         response, (json) => ClientServiceRequestModel.fromJson(json));
//   }

//   @override
//   Future<ApiResponse<List<ClientServiceRequestModel>>>
//       getClientServiceRequests() async {
//     final response = await _apiClient.get(Endpoints.serviceRequest);
//     return ApiResponse.fromJson(
//         response,
//         (data) => SafeMapper.mapList(
//             data as List?, (json) => ClientServiceRequestModel.fromJson(json)));
//     // return ApiResponse.fromJson(json, fromJsonT)
//   }

//   @override
//   Future<ApiResponse<WorkorderModel>> approveClientServiceRequest(
//       String id) async {
//     final response = await _apiClient
//         .put('${Endpoints.serviceRequest.byId(id)}/approve');
//     return ApiResponse.fromJson(
//       response,
//       (data) => WorkorderModel.fromJson(data),
//     );
//   }

//   @override
//   Future<ApiResponse<ClientServiceRequestModel>> cancelClientServiceRequest(
//       String id) {
//     // TODO: implement cancelClientServiceRequest
//     throw UnimplementedError();
//   }

//   @override
//   Future<ApiResponse<ClientServiceRequestModel>> rejectClientServiceRequest(
//       String id) async {
//     final response = await _apiClient
//         .put('${Endpoints.serviceRequest.byId(id)}/reject');
//     return ApiResponse.fromJson(
//       response,
//       (data) => ClientServiceRequestModel.fromJson(data),
//     );
//   }
// }
