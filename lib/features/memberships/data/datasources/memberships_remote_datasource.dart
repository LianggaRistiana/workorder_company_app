import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';

abstract class MembershipsRemoteDatasource {
  ApiFutureList<MembershipCodeModel> getMembershipCodes();
  ApiFutureList<MemberModel> getMembers();
  ApiFutureList<MembershipCodeModel> uploadMembershipCsvFile(String filePath);
  ApiFuture<ExternalUserModel> claimMembership(String token, String companyId);
  ApiFuture<MembershipCodeModel> deleteMemberShipCode(String id);
}

class MembershipsRemoteDatasourceImpl implements MembershipsRemoteDatasource {
  final ApiClient _apiClient;

  MembershipsRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ExternalUserModel> claimMembership(
    String token,
    String companyId,
  ) async {
    final response = await _apiClient.post(Endpoints.claimMembership, data: {
      "code": token,
      "companyId": companyId,
    });
    return ApiResponse<ExternalUserModel>.fromJson(
      response,
      (data) => ExternalUserModel.fromJson(data),
    );
  }

  @override
  ApiFuture<MembershipCodeModel> deleteMemberShipCode(String id) async {
    final response =
        await _apiClient.delete(Endpoints.membershipCodes.byId(id));
    return ApiResponse<MembershipCodeModel>.fromJson(
      response,
      (data) => MembershipCodeModel.fromJson(data),
    );
  }

  @override
  ApiFutureList<MembershipCodeModel> getMembershipCodes() async {
    final response = await _apiClient.get(Endpoints.membershipCodes);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => MembershipCodeModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFutureList<MemberModel> getMembers() async {
    final response = await _apiClient.get(Endpoints.memberships);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => MemberModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFutureList<MembershipCodeModel> uploadMembershipCsvFile(
      String filePath) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath),
    });

    final response = await _apiClient.postFormData(Endpoints.membershipCodes,
        data: formData);
    return ApiResponse.fromJson(
        response,
        (response) => SafeMapper.mapList(
              response,
              (json) => MembershipCodeModel.fromJson(json),
            ));
  }
}
