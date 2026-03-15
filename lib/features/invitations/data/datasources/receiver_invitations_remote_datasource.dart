import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';

abstract class ReceiverInvitationsRemoteDatasource {
  Future<ApiResponse<InvitationModel>> acceptInvitation(String id);
  Future<ApiResponse<InvitationModel>> rejectInvitation(String id);
  Future<ApiResponse<List<InvitationModel>>> getPendingInvitations();
}

class ReceiverInvitationsRemoteDatasourceImpl
    implements ReceiverInvitationsRemoteDatasource {
  final ApiClient _apiClient;

  ReceiverInvitationsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<InvitationModel>> acceptInvitation(String id) {
    // TODO: implement acceptInvitation
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<InvitationModel>>> getPendingInvitations() async {
    final response = await _apiClient.get(Endpoints.pendingInvitations);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => InvitationModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<InvitationModel>> rejectInvitation(String id) {
    // TODO: implement rejectInvitation
    throw UnimplementedError();
  }
}
