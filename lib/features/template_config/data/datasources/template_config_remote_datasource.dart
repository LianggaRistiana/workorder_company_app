import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/company_type_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/selected_service_template_payload_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_preview_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class TemplateConfigRemoteDatasource {
  ApiFutureList<CompanyTypeModel> getCompanyTypes();
  ApiFutureList<ServiceTemplateModel> getServiceTemplates(String companyTypeId);
  ApiFuture<ServiceTemplatePreviewModel> getServiceTemplatePreview(
      String serviceTemplateId);
  ApiFutureList<ServiceModel> generateServices(
    SelectedServiceTemplatePayloadModel payload,
  );
}

class TemplateConfigRemoteDatasourceImpl
    implements TemplateConfigRemoteDatasource {
  final ApiClient _apiClient;

  TemplateConfigRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<ServiceModel> generateServices(
      SelectedServiceTemplatePayloadModel payload) async {
    final response = await _apiClient.post(Endpoints.generateServices,
        data: payload.toJson());
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => ServiceModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFutureList<CompanyTypeModel> getCompanyTypes() async {
    final response = await _apiClient.get(Endpoints.companyType);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => CompanyTypeModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<ServiceTemplatePreviewModel> getServiceTemplatePreview(
      String serviceTemplateId) async {
    final response = await _apiClient
        .get(Endpoints.serviceTemplatePreview.fillId(serviceTemplateId));
    return ApiResponse.fromJson(
      response,
      (data) => ServiceTemplatePreviewModel.fromJson(data),
    );
  }

  @override
  ApiFutureList<ServiceTemplateModel> getServiceTemplates(
      String companyTypeId) async {
    final response = await _apiClient.get(
      Endpoints.serviceTemplates.fillId(companyTypeId),
    );
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => ServiceTemplateModel.fromJson(json),
      ),
    );
  }
}
