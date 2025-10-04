import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

abstract class FormsRemoteDatasource {
  Future<ApiResponse<List<FormModel>>> getForms();
  Future<ApiResponse<FormModel>> getFormById(String id);
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
    final response = await _apiClient.get(Endpoints.form(id));
    return ApiResponse<FormModel>.fromJson(
      response,
      (data) => FormModel.fromJson(data['form']),
    );
  }
}
