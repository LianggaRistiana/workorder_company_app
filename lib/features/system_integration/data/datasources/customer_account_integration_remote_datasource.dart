import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/start_pairing_data_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class CustomerAccountIntegrationRemoteDatasource {
  ApiFuture<StartPairingDataModel> startPairing(
    String companyId,
  );
  ApiFuture<ExternalUserModel> completePairing({
    required String companyId,
    required String code,
    required String state,
  });
  ApiFuture<ExternalUserModel> getAccountPairingStatus(String companyId);
  ApiFuture<ExternalUserModel> detachAccountPairing(String companyId);
  ApiFutureList<ExternalUserModel> getAllAccountsPairingStatus();
}

class CustomerAccountIntegrationRemoteDatasourceImpl
    implements CustomerAccountIntegrationRemoteDatasource {
  final ApiClient _apiClient;

  CustomerAccountIntegrationRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ExternalUserModel> completePairing(
      {required String companyId,
      required String code,
      required String state}) async {
    final response = await _apiClient.post(
      Endpoints.completePairing,
      data: {
        "company_id": companyId,
        "code": code,
        "state": state,
      },
    );
    return ApiResponse.fromJson(
        response, (json) => ExternalUserModel.fromJson(json));
  }

  @override
  ApiFuture<ExternalUserModel> detachAccountPairing(String companyId) async {
    final response = await _apiClient
        .delete(Endpoints.detachAccountPairing.fillId(companyId));
    return ApiResponse.fromJson(
        response, (json) => ExternalUserModel.fromJson(json));
  }

  @override
  ApiFuture<ExternalUserModel> getAccountPairingStatus(String companyId) async {
    final response = await _apiClient.get(
      Endpoints.accountPairing.fillId(companyId),
    );
    return ApiResponse.fromJson(
        response, (json) => ExternalUserModel.fromJson(json));
  }

  @override
  ApiFutureList<ExternalUserModel> getAllAccountsPairingStatus() async {
    final response = await _apiClient.get(Endpoints.allAccountPairing);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => ExternalUserModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<StartPairingDataModel> startPairing(String companyId) async {
    final response = await _apiClient.post(
      Endpoints.startPairing,
      data: {
        "company_id": companyId,
        "redirect_base_url": "com.workorder.saas://pair/callback"
      },
    );
    return ApiResponse.fromJson(
        response, (json) => StartPairingDataModel.fromJson(json));
  }
}
