import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

abstract class EmployeesRemoteDatasource {
  Future<ApiResponse<List<UserModel>>> getEmployees();
}

class EmployeesRemoteDatasourceImpl implements EmployeesRemoteDatasource {
  final ApiClient _apiClient;

  EmployeesRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<UserModel>>> getEmployees() async {
    return _apiClient.get<ApiResponse<List<UserModel>>>(
      Endpoints.employees,
      fromJson: (json) => ApiResponse<List<UserModel>>.fromJson(
        json,
        (data) {
          final employees = (data['employees'] as List?) ?? [];
          return employees.map((e) => UserModel.fromJson(e)).toList();
        },
      ),
    );
  }
  // @override
  // Future<ApiResponse<List<UserModel>>> getEmployees() async {
  //   final response = await _apiClient.get(Endpoints.employees);

  //   return ApiResponse<List<UserModel>>.fromJson(
  //     response,
  //     (data) {
  //       if (data == null) return <UserModel>[]; // fallback kalau null
  //       return (data as List).map((e) => UserModel.fromJson(e)).toList();
  //     },
  //   );
      // return ApiResponse<List<UserModel>>.fromJson(
    //   response,
    //   (data) {
    //     if (data == null) return <UserModel>[];

    //     final employees = (data['employees'] as List?) ?? [];
    //     return employees.map((e) => UserModel.fromJson(e)).toList();
    //   },
    // );
  // }
}
