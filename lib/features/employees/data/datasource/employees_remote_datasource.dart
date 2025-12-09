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

    // return ApiResponse<List<UserModel>>.fromJson(response, (data) {
    //   final employees = (data['employees'] as List?) ?? [];
    //   return employees.map((e) => UserModel.fromJson(e)).toList();
    // });

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => UserModel.fromJson(json),
      ),
    );

    //   Endpoints.employees,
    // return _apiClient.get<ApiResponse<List<UserModel>>>(
    //   Endpoints.employees,
    //   fromJson: (json) => ApiResponse<List<UserModel>>.fromJson(
    //     json,
    //     (data) {
    //       final employees = (data['employees'] as List?) ?? [];
    //       return employees.map((e) => UserModel.fromJson(e)).toList();
    //     },
    //   ),
    // );
  }
}
