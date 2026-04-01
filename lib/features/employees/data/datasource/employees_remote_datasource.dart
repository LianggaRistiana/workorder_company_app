import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

abstract class EmployeesRemoteDatasource {
  Future<ApiResponse<List<UserModel>>> getEmployees();
}

class EmployeesRemoteDatasourceImpl implements EmployeesRemoteDatasource {
  final ApiClient _apiClient;

  EmployeesRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<UserModel>>> getEmployees() async {
    final response = await _apiClient.get(Endpoints.employees);

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => UserModel.fromJson(json),
      ),
    );
  }
}
