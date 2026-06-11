import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

abstract class EmployeesRemoteDatasource {
  Future<ApiResponse<List<UserModel>>> getEmployees();
  ApiFutureWithMeta<Empty> getEmployeeByDetail(String id);
  ApiFuture<Empty> kickEmployee(String email);
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

  @override
  ApiFutureWithMeta<Empty> getEmployeeByDetail(String id) async {
    final response = await _apiClient
        .get(Endpoints.employees.byId(id));
    return ApiResponseWithMeta<Empty>.fromJson(
      response,
      (data) => Empty(),
    );
  }

  @override
  ApiFuture<Empty> kickEmployee(String email) async {
    final response =
        await _apiClient.delete(Endpoints.employees, data: {"email": email});
    return ApiResponse.fromJson(
      response,
      (data) => Empty(),
    );
  }
}
