import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/services/data/models/service_model.dart';

abstract class CompanyRemoteDatasource {
  Future<ApiResponse<CompanyModel>> getCompanyById(String id);
  Future<ApiResponse<List<CompanyModel>>> getCompanies();
  Future<ApiResponse<List<ServiceModel>>> getCompanyService(String id);
}


// TODO : refactor the name of this datasource this into public company datasource
class CompanyRemoteDatasourceImpl implements CompanyRemoteDatasource {
  final ApiClient _apiClient;

  CompanyRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<CompanyModel>>> getCompanies() async {
    final response = await _apiClient.get(Endpoints.publicCompanies);

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data as List?,
        (json) => CompanyModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<CompanyModel>> getCompanyById(String id) async {
    final response = await _apiClient.get(Endpoints.publicCompanies.byId(id));

    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<List<ServiceModel>>> getCompanyService(String id) async {
    final response = await _apiClient.get(Endpoints.publicCompanyServices(id));

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data as List?,
        (json) => ServiceModel.fromJson(json),
      ),
    );
  }
}
