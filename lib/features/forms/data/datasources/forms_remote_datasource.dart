import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

abstract class FormsRemoteDatasource {
  ApiFutureList<FormModel> getForms();
  ApiFutureWithMeta<FormModel> getFormById(String id);
  ApiFuture<FormModel> createForm(FormModel form);
  ApiFuture<FormModel> updateForm(FormModel form);
  ApiFuture<Empty> deleteForm(
      FormModel form); // TODO : Test endtoend delete form
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
  ApiFutureWithMeta<FormModel> getFormById(String id) async {
    final response = await _apiClient.get(Endpoints.forms.byId(id));
    return ApiResponseWithMeta<FormModel>.fromJson(
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
  ApiFuture<FormModel> updateForm(FormModel form) async {
    final response = await _apiClient.put(Endpoints.forms.byId(form.id),
        data: form.toJson());
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data),
    );
  }

  @override
  ApiFuture<Empty> deleteForm(FormModel form) async {
    final response = await _apiClient.delete(Endpoints.forms.byId(form.id));
    return ApiResponse.fromJson(
      response,
      (data) => Empty(),
    );
  }
}
