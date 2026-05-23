import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class ServicePriceRemoteDatasource {
  ApiFutureList<ServicePriceModel> getServicePrices();
  ApiFuture<ServicePriceModel> addServicePrice(ServicePriceModel model);
  ApiFuture<ServicePriceModel> updateServicePrice(ServicePriceModel model);
  ApiFuture<ServicePriceModel> deleteServicePrice(String id);
}

class ServicePriceRemoteDatasourceImpl implements ServicePriceRemoteDatasource {
  final ApiClient _apiClient;

  ServicePriceRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ServicePriceModel> addServicePrice(ServicePriceModel model) async {
    final response =
        await _apiClient.post(Endpoints.servicePrice, data: model.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => ServicePriceModel.fromJson(json),
    );
  }

  @override
  ApiFuture<ServicePriceModel> deleteServicePrice(String id) async {
    final response =
        await _apiClient.delete(Endpoints.servicePriceDetail.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => ServicePriceModel.fromJson(json),
    );
  }

  @override
  ApiFutureList<ServicePriceModel> getServicePrices() async {
    final response = await _apiClient.get(Endpoints.servicePrice);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => ServicePriceModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<ServicePriceModel> updateServicePrice(
      ServicePriceModel model) async {
    final response =
        await _apiClient.put(Endpoints.servicePrice, data: model.toJson());
    return ApiResponse.fromJson(
      response,
      (json) => ServicePriceModel.fromJson(json),
    );
  }
}
