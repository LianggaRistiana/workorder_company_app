import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/service_request/data/model/provider_service_request_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class ProviderServiceRequestRemoteDatasource {
  ApiFutureList<ProviderServiceRequestModel> getServiceRequests();
  ApiFuture<ProviderServiceRequestModel> getServiceRequestDetail(String id);
  ApiFuture<ProviderServiceRequestModel> approveServiceRequest(String id);
  ApiFuture<ProviderServiceRequestModel> rejectServiceRequest(String id);
}

class ProviderServiceRequestRemoteDatasourceImpl
    implements ProviderServiceRequestRemoteDatasource {
  final ApiClient _apiClient;

  ProviderServiceRequestRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ProviderServiceRequestModel> approveServiceRequest(
      String id) async {
    final response =
        await _apiClient.patch(Endpoints.serviceRequestApprove.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => ProviderServiceRequestModel.fromJson(json),
    );
  }

  @override
  ApiFuture<ProviderServiceRequestModel> getServiceRequestDetail(
      String id) async {
    final response =
        await _apiClient.get(Endpoints.serviceRequestDetail.fillId(id));
    return ApiResponse.fromJson(
      response,
      (data) => ProviderServiceRequestModel.fromJson(data),
    );
  }

  @override
  ApiFutureList<ProviderServiceRequestModel> getServiceRequests() async {
    final response = await _apiClient.get(Endpoints.serviceRequestInbox);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => ProviderServiceRequestModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<ProviderServiceRequestModel> rejectServiceRequest(String id) async {
    final response =
        await _apiClient.patch(Endpoints.serviceRequestReject.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => ProviderServiceRequestModel.fromJson(json),
    );
  }
}
