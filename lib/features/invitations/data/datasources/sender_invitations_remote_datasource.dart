import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_draft_model.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class SenderInvitationsRemoteDatasource {
  Future<ApiResponse<List<InvitationModel>>> getInvitationsHistory();
  Future<ApiResponse<List<InvitationModel>>> inviteEmployees(
    List<InvitationDraftModel> invitationsData,
  );
  Future<ApiResponse<InvitationModel>> cancelInvitation(String id);
}

class SenderInvitationsRemoteDatasourceImpl
    implements SenderInvitationsRemoteDatasource {
  final ApiClient _apiClient;

  SenderInvitationsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<InvitationModel>> cancelInvitation(String id) async {
    final response =
        await _apiClient.put(Endpoints.cancelInvitations.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationModel.fromJson(json),
    );
  }


// FIXME : told BE fis response
  @override
  Future<ApiResponse<List<InvitationModel>>> getInvitationsHistory() async {
    final response = await _apiClient.get(Endpoints.historyInvitations);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data['invitations'],
        (json) => InvitationModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<List<InvitationModel>>> inviteEmployees(
      List<InvitationDraftModel> invitationsData) async {
    final response = await _apiClient.post(Endpoints.inviteEmployees,
        data: {"invites": invitationsData.map((e) => e.toJson()).toList()});

    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => InvitationModel.fromJson(json),
      ),
    );
  }
}
