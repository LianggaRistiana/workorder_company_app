import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<LoginResponseModel>> login(String email, String password);
  Future<ApiResponse<UserModel>> register(
    String name,
    String email,
    String password,
  );
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<LoginResponseModel>> login(
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      Endpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    return ApiResponse<LoginResponseModel>.fromJson(
      response,
      (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<UserModel>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      Endpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return ApiResponse<UserModel>.fromJson(
      response,
      (json) => UserModel.fromJson(json),
    );
  }
}
