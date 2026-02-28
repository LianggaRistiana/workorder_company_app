import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitations_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// NOTE : not tested yet
abstract class InvitationsRemoteDatasource {
  Future<ApiResponse<List<InvitationsModel>>> getInvitationsHistory();
  Future<ApiResponse<List<InvitationsModel>>> inviteEmployees(
      InvitationsModel invitationsData);
  Future<ApiResponse<InvitationsModel>> acceptInvitation(String id);
  Future<ApiResponse<InvitationsModel>> rejectInvitation(String id);
  Future<ApiResponse<InvitationsModel>> cancelInvitation(String id);
}

class InvitationsRemoteDatasourceImpl implements InvitationsRemoteDatasource {
  final ApiClient _apiClient;

  InvitationsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<InvitationsModel>> acceptInvitation(String id) async {
    final response =
        await _apiClient.put(Endpoints.acceptInvitations.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationsModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<InvitationsModel>> cancelInvitation(String id) async {
    final response =
        await _apiClient.put(Endpoints.cancelInvitations.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationsModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<InvitationsModel>>> getInvitationsHistory() async {
    final response = await _apiClient.get(Endpoints.historyInvitations);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => InvitationsModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<List<InvitationsModel>>> inviteEmployees(
      InvitationsModel invitationsData) async {
    final response = await _apiClient.post(Endpoints.inviteEmployees,
        data: invitationsData.toJson());
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => InvitationsModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<InvitationsModel>> rejectInvitation(String id) async {
    final response =
        await _apiClient.put(Endpoints.rejectInvitations.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => InvitationsModel.fromJson(json),
    );
  }
}
