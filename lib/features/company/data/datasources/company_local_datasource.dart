import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_with_service_model.dart';

abstract class CompanyLocalDatasource {
  Future<ApiResponse<CompanyWithServiceModel>> getCompanyById(String id);
  Future<ApiResponse<List<CompanyModel>>> getCompanies();
}

class CompanyLocalDatasourceImpl implements CompanyLocalDatasource {
  final ApiClient _apiClient;

  CompanyLocalDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<CompanyModel>>> getCompanies() async {
    final response = await _apiClient.get(Endpoints.companies);

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data as List?,
        (json) => CompanyModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<CompanyWithServiceModel>> getCompanyById(String id) async {
    final response = await _apiClient.get(Endpoints.companiesWithId(id));
    
    // TODO : add safe mapper for service list
    return ApiResponse.fromJson(
      response,
      (data) => CompanyWithServiceModel.fromJson(data),
    );
  }
}
