import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/ordered_form_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

abstract class FormsRemoteDatasource {
  Future<ApiResponse<List<FormModel>>> getForms();
  Future<ApiResponse<List<OrderedFormModel>>> publicGetServiceForms(String id);
  Future<ApiResponse<void>> publicSubmitIntakeForms(
      String id, List<SubmissionsModel> submissions);
  Future<ApiResponse<FormModel>> getFormById(String id);
  Future<ApiResponse<FormModel>> createForm(FormModel form);
}

class FormsRemoteDatasourceImpl implements FormsRemoteDatasource {
  final ApiClient _apiClient;

  FormsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<FormModel>>> getForms() async {
    final response = await _apiClient.get(Endpoints.forms);

    return ApiResponse.fromJson(
      response,
      (data) => ((data as Map<String, dynamic>?)?['forms'] as List? ?? [])
          .map((e) => FormModel.fromJson(e))
          .toList(),
    );
  }

  @override
  Future<ApiResponse<FormModel>> getFormById(String id) async {
    final response = await _apiClient.get(Endpoints.forms.byId(id));
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data['form']),
    );
  }

  @override
  Future<ApiResponse<FormModel>> createForm(FormModel form) async {
    final response =
        await _apiClient.post(Endpoints.forms, data: form.toJson());
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data['form']),
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
        data: submissions);
    return ApiResponse<void>.fromJson(
      response,
      (data) => {},
    );
  }
}
