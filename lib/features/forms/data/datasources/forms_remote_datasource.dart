import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/ordered_form_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

abstract class FormsRemoteDatasource {
  // TODO : REFACTOR THIS INTO SERVICE REQUEST FEATURE
  Future<ApiResponse<List<OrderedFormModel>>> publicGetServiceForms(String id);
  Future<ApiResponse<void>> publicSubmitIntakeForms(
      String id, List<SubmissionsModel> submissions);

  ApiFutureList<FormModel> getForms();
  ApiFuture<FormModel> getFormById(String id);
  ApiFuture<FormModel> createForm(FormModel form);
  ApiFuture<FormModel> updateForm(FormModel form);
}

class FormsRemoteDatasourceImpl implements FormsRemoteDatasource {
  final ApiClient _apiClient;

  FormsRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<FormModel> getForms() async {
    final response = await _apiClient.get(Endpoints.forms);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => FormModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<FormModel> getFormById(String id) async {
    final response = await _apiClient.get(Endpoints.forms.byId(id));
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data),
    );
  }

  @override
  ApiFuture<FormModel> createForm(FormModel form) async {
    final response =
        await _apiClient.post(Endpoints.forms, data: form.toJson());
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<List<OrderedFormModel>>> publicGetServiceForms(
      String id) async {
    final response = await _apiClient.get(Endpoints.publicIntakeForms(id));

    return ApiResponse<List<OrderedFormModel>>.fromJson(
      response,
      (data) => (data as List<dynamic>? ?? [])
          .map((e) => OrderedFormModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<void>> publicSubmitIntakeForms(
      String id, List<SubmissionsModel> submissions) async {
    final response = await _apiClient.post(Endpoints.publicIntakeForms(id),
        data: {"submissions": submissions});
    return ApiResponse<void>.fromJson(
      response,
      (data) => {},
    );
  }

  @override
  ApiFuture<FormModel> updateForm(FormModel form) async {
    final response = await _apiClient.put(Endpoints.forms.byId(form.id),
        data: form.toJson());
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data),
    );
  }
}
