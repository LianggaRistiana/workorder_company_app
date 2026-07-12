import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

abstract class PublicCompaniesRemoteDatasource {
  ApiFutureWithMeta<CompanyModel> getCompanyById(String id);
  ApiFutureList<CompanyModel> getCompanies({String? keyword});
}

class PublicCompaniesRemoteDatasourceImpl
    implements PublicCompaniesRemoteDatasource {
  final ApiClient _apiClient;

  PublicCompaniesRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<CompanyModel> getCompanies({String? keyword}) async {
    final endpoint = Endpoints.publicCompanies.withQuery({
      'keyword': keyword,
    });

    final response = await _apiClient.get(endpoint);

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data as List?,
        (json) => CompanyModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFutureWithMeta<CompanyModel> getCompanyById(String id) async {
    final response = await _apiClient.get(Endpoints.publicCompanies.byId(id));

    return ApiResponseWithMeta.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }
}
