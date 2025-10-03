import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

abstract class FormsRemoteDatasource {
  Future<ApiResponse<List<FormModel>>> getForms();
}

class FormsRemoteDatasourceImpl implements FormsRemoteDatasource {
  final ApiClient _apiClient;

  FormsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<FormModel>>> getForms() async {
    return _apiClient.get<ApiResponse<List<FormModel>>>(
      Endpoints.forms,
      fromJson: (json) {
        return ApiResponse.fromJson(
          json,
          (data) {
            final formsJson = (data as Map<String, dynamic>?)?['forms'] as List? ?? [];
            return formsJson.map((e) => FormModel.fromJson(e)).toList();
          },
        );
      },
    );
  }
}
