import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/model/company_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/logout_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/data/model/user_registration_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<LoginResponseModel>> login(String email, String password);
  Future<ApiResponse<LogoutResponseModel>> logout();
  ApiFuture<UserModel> getUser();
  Future userRegistration(UserRegistrationModel registrationData);
  Future companyRegistration(CompanyRegistrationModel registrationData);
  Future verifyOtp(String email, String otp);
  Future resendOtp(String email);
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
  Future<ApiResponse<LogoutResponseModel>> logout() async {
    final response = await _apiClient.post(Endpoints.logout);

    return ApiResponse<LogoutResponseModel>.fromJson(
      response,
      (data) => LogoutResponseModel.fromJson(data),
    );
  }

  @override
  Future companyRegistration(
    CompanyRegistrationModel registrationData,
  ) async {
    await _apiClient.post(
      Endpoints.registerCompany,
      data: registrationData.toJson(),
    );
    return;
  }

  @override
  Future userRegistration(
    UserRegistrationModel registrationData,
  ) async {
    await _apiClient.post(
      Endpoints.register,
      data: registrationData.toJson(),
    );
    return;
  }

  @override
  ApiFuture<UserModel> getUser() async {
    final data = await _apiClient.get(Endpoints.profile);
    return ApiResponse.fromJson(data, (json) => UserModel.fromJson(json));
  }

  @override
  Future verifyOtp(String email, String otp) async {
    await _apiClient.post(
      Endpoints.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
    return;
  }

  @override
  Future resendOtp(String email) async {
    await _apiClient.post(
      Endpoints.resendOtp,
      data: {'email': email},
    );
    return;
  }
}
