import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/logout_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<LoginResponseModel>> login(String email, String password);
  Future<ApiResponse<UserModel>> register(
    String name,
    String email,
    String password,
  );
  Future<ApiResponse<LogoutResponseModel>> logout();
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

  @override
  Future<ApiResponse<LogoutResponseModel>> logout() async {
    final response = await _apiClient.post(Endpoints.logout);

    return ApiResponse<LogoutResponseModel>.fromJson(
      response,
      (data) => LogoutResponseModel.fromJson(data),
    );
  }
}
