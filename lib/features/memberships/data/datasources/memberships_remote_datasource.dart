import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_generate_draft_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class MembershipsRemoteDatasource {
  Future<ApiResponse<List<MembershipModel>>> getMemberships();
  Future<ApiResponse<List<MembershipModel>>> generateMembershipCodes(
      MembershipCodeGenerateDraftModel draft);
  Future<ApiResponse<CompanyModel>> claimMembership(String code);
  Future<ApiResponse<MembershipModel>> deleteMembership(String id);
}

class MembershipsRemoteDatasourceImpl implements MembershipsRemoteDatasource {
  final ApiClient _apiClient;

  MembershipsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<CompanyModel>> claimMembership(String code) async {
    final response =
        await _apiClient.post(Endpoints.claimMembership, data: {"code": code});
    return ApiResponse<CompanyModel>.fromJson(
      response,
      (data) => CompanyModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<MembershipModel>> deleteMembership(String id) async {
    final response =
        await _apiClient.delete(Endpoints.deleteMembership.fillId(id));
    return ApiResponse<MembershipModel>.fromJson(
      response,
      (data) => MembershipModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<List<MembershipModel>>> generateMembershipCodes(
      MembershipCodeGenerateDraftModel draft) async {
    final response = await _apiClient.post(Endpoints.generateMembershipCode,
        data: draft.toJson());
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => MembershipModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<List<MembershipModel>>> getMemberships() async {
    final response = await _apiClient.get(Endpoints.memberships);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => MembershipModel.fromJson(json),
      ),
    );
  }
}
