import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/invitation_codes/data/models/invitation_code_model.dart';
import 'package:workorder_company_app/features/invitation_codes/data/models/invitation_code_preview_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class InvitationCodesRemoteDatasource {
  // Company side
  Future<ApiResponse<List<InvitationCodeModel>>> getInvitationCodes();
  Future<ApiResponse<InvitationCodeModel>> getInvitationCodeById(String id);
  Future<ApiResponse<InvitationCodeModel>> createInvitationCode(Map<String, dynamic> body);
  Future<ApiResponse<InvitationCodeModel>> updateInvitationCode(String id, Map<String, dynamic> body);
  Future<ApiResponse<Map<String, dynamic>>> revokeInvitationCode(String id);

  // Employee side
  Future<ApiResponse<InvitationCodePreviewModel>> previewInvitationCode(String code);
  Future<ApiResponse<Map<String, dynamic>>> claimInvitationCode(String code);
}

class InvitationCodesRemoteDatasourceImpl implements InvitationCodesRemoteDatasource {
  final ApiClient _apiClient;

  InvitationCodesRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<InvitationCodeModel>>> getInvitationCodes() async {
    final response = await _apiClient.get(Endpoints.invitationCodes);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(data, (json) => InvitationCodeModel.fromJson(json)),
    );
  }

  @override
  Future<ApiResponse<InvitationCodeModel>> getInvitationCodeById(String id) async {
    final response = await _apiClient.get(Endpoints.invitationCodeDetail.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationCodeModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<InvitationCodeModel>> createInvitationCode(Map<String, dynamic> body) async {
    final response = await _apiClient.post(Endpoints.invitationCodes, data: body);
    return ApiResponse.fromJson(
      response,
      (json) => InvitationCodeModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<InvitationCodeModel>> updateInvitationCode(String id, Map<String, dynamic> body) async {
    final response = await _apiClient.patch(Endpoints.invitationCodeDetail.fillId(id), data: body);
    return ApiResponse.fromJson(
      response,
      (json) => InvitationCodeModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> revokeInvitationCode(String id) async {
    final response = await _apiClient.delete(Endpoints.invitationCodeDetail.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
  }

  @override
  Future<ApiResponse<InvitationCodePreviewModel>> previewInvitationCode(String code) async {
    final response = await _apiClient.get(Endpoints.invitationCodePreview.fillId(code));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationCodePreviewModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> claimInvitationCode(String code) async {
    final response = await _apiClient.post(Endpoints.invitationCodeClaim, data: {'code': code});
    return ApiResponse.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
  }
}
