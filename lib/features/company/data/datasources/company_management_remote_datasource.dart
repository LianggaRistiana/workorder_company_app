import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

abstract class CompanyManagementRemoteDatasource {
  Future<ApiResponse<CompanyModel>> getCompanyInformation();
  Future<ApiResponse<CompanyModel>> updateCompanyInformation(
      CompanyModel companyModel);
}

class CompanyManagementRemoteDatasourceImpl
    implements CompanyManagementRemoteDatasource {
  final ApiClient _apiClient;

  CompanyManagementRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<CompanyModel>> getCompanyInformation() async {
    final response = await _apiClient.get(Endpoints.company);
    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<CompanyModel>> updateCompanyInformation(
      CompanyModel companyModel) async {
    final response =
        await _apiClient.put(Endpoints.company, data: companyModel.toJson());

    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }
}
