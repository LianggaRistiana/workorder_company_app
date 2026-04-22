import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

abstract class PublicServicesRemoteDatasource {
  ApiFutureList<ServiceSummaryModel> getPublicServices(String companyId);
  ApiFuture<ServiceModel> getPublicServiceDetails(String serviceId);
}

class PublicServicesRemoteDatasourceImpl
    implements PublicServicesRemoteDatasource {
  final ApiClient _apiClient;

  PublicServicesRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<ServiceSummaryModel> getPublicServices(String companyId) async {
    final response =
        await _apiClient.get(Endpoints.publicCompanyServices(companyId));

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data['services'] as List?, // FIXME[API REQUIRED] : BE SHOULD Fix THIS Response. destruct servcie direct to data, remove isSubcribbed info from this endpoint
        (json) => ServiceSummaryModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<ServiceModel> getPublicServiceDetails(String serviceId) {
    // TODO[High]: implement getPublicServiceDetails
    throw UnimplementedError();
  }
}
