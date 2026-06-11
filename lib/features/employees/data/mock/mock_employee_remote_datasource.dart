import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/mock/user_mock_factory.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';

class MockEmployeeRemoteDatasource implements EmployeesRemoteDatasource {
  final factory = UserMockFactory();

  @override
  Future<ApiResponse<List<UserModel>>> getEmployees() async {
    final users = List.generate(100, (_) => factory.createModel());
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse(message: "good", data: users);
  }

  @override
  ApiFutureWithMeta<Empty> getEmployeeByDetail(String id) {
    // TODO: implement getEmployeeById
    throw UnimplementedError();
  }

  @override
  ApiFuture<Empty> kickEmployee(String email) {
    // TODO: implement kickEmployee
    throw UnimplementedError();
  }
}
