import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_codes_generate_draft_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class MembershipsRemoteDatasource {
  ApiFutureList<MembershipCodeModel> getMembershipCodes();
  ApiFutureList<MemberModel> getMembers();
  ApiFutureList<MembershipCodeModel> generateMembershipCodes(
      MembershipCodesGenerateDraftModel draft);
  ApiFuture<CompanyModel> claimMembership(String code);
  ApiFuture<MembershipCodeModel> deleteMembership(String id);
}

class MembershipsRemoteDatasourceImpl implements MembershipsRemoteDatasource {
  final ApiClient _apiClient;

  MembershipsRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<CompanyModel> claimMembership(String code) async {
    final response =
        await _apiClient.post(Endpoints.claimMembership, data: {"code": code});
    return ApiResponse<CompanyModel>.fromJson(
      response,
      (data) => CompanyModel.fromJson(data["company"]),
    );
  }

  @override
  ApiFuture<MembershipCodeModel> deleteMembership(String id) async {
    final response =
        await _apiClient.delete(Endpoints.deleteMembership.fillId(id));
    return ApiResponse<MembershipCodeModel>.fromJson(
      response,
      (data) => MembershipCodeModel.fromJson(data),
    );
  }

  @override
  ApiFutureList<MembershipCodeModel> generateMembershipCodes(
      MembershipCodesGenerateDraftModel draft) async {
    final response = await _apiClient.post(Endpoints.generateMembershipCode,
        data: draft.toJson());
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => MembershipCodeModel.fromJson(json),
      ),
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
}
