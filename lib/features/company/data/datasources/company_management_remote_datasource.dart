import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

abstract class CompanyManagementRemoteDatasource {
  ApiFuture<CompanyModel> getCompanyInformation();
  ApiFuture<CompanyModel> updateCompanyInformation(
      CompanyModel companyModel);
}

class CompanyManagementRemoteDatasourceImpl
    implements CompanyManagementRemoteDatasource {
  final ApiClient _apiClient;

  CompanyManagementRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<CompanyModel> getCompanyInformation() async {
    final response = await _apiClient.get(Endpoints.company);
    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }

  @override
  ApiFuture<CompanyModel> updateCompanyInformation(
      CompanyModel companyModel) async {
    final response =
        await _apiClient.put(Endpoints.company, data: companyModel.toJson());

    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }
}
