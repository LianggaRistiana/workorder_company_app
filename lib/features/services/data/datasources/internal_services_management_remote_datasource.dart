import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class InternalServicesManagementRemoteDatasource {
  ApiFutureList<ServiceSummaryModel> getServices();
  ApiFuture<ServiceModel> getServiceById(String id);
  ApiFuture<ServiceModel> createService(ServiceModel service);
  ApiFuture<ServiceModel> toggleActive(ServiceModel service);
  ApiFuture<ServiceModel> removeService(String serviceId);
  ApiFuture<ServiceModel> updateService(ServiceModel service);
}

class InternalServicesManagementRemoteDatasourceImpl
    implements InternalServicesManagementRemoteDatasource {
  final ApiClient _apiClient;

  InternalServicesManagementRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ServiceModel> createService(ServiceModel service) async {
    final response =
        await _apiClient.post(Endpoints.services, data: service.toJson());
    return ApiResponse<ServiceModel>.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }

  @override
  ApiFuture<ServiceModel> getServiceById(String id) async {
    final response = await _apiClient.get(Endpoints.services.byId(id));
    return ApiResponse.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }

  @override
  ApiFutureList<ServiceSummaryModel> getServices() async {
    final response = await _apiClient.get(Endpoints.services);

    return ApiResponse.fromJson(
      response,
      (data) => (data as List<dynamic>? ?? [])
          .map((e) => ServiceSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  ApiFuture<ServiceModel> updateService(ServiceModel service) async {
    final response = await _apiClient.put(Endpoints.services.byId(service.id),
        data: service.toJson());
    return ApiResponse<ServiceModel>.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }

  @override
  ApiFuture<ServiceModel> removeService(String serviceId) async {
    final response =
        await _apiClient.delete(Endpoints.services.byId(serviceId));
    return ApiResponse<ServiceModel>.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }

  @override
  ApiFuture<ServiceModel> toggleActive(ServiceModel service) async {
    final response = await _apiClient.patch(
        Endpoints.servicesToggleActive.fillId(service.id),
        data: {"isActive": service.isActive ? false : true});
    return ApiResponse<ServiceModel>.fromJson(
        response, (data) => ServiceModel.fromJson(data));
  }
}
