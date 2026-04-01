import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

abstract class PublicCompaniesRemoteDatasource {
  ApiFuture<CompanyModel> getCompanyById(String id);
  ApiFutureList<CompanyModel> getCompanies();
}

class PublicCompaniesRemoteDatasourceImpl
    implements PublicCompaniesRemoteDatasource {
  final ApiClient _apiClient;

  PublicCompaniesRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<CompanyModel> getCompanies() async {
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
  ApiFuture<CompanyModel> getCompanyById(String id) async {
    final response = await _apiClient.get(Endpoints.publicCompanies.byId(id));

    return ApiResponse.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }
}
