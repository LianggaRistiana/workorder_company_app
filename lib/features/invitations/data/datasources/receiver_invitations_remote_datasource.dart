import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';

abstract class ReceiverInvitationsRemoteDatasource {
  Future<ApiResponse<InvitationModel>> acceptInvitation(String id);
  Future<ApiResponse<InvitationModel>> rejectInvitation(String id);
  Future<ApiResponse<List<InvitationModel>>> getPendingInvitations();
}

class ReceiverInvitationsRemoteDatasourceImpl
    implements ReceiverInvitationsRemoteDatasource {
  @override
  Future<ApiResponse<InvitationModel>> acceptInvitation(String id) {
    // TODO: implement acceptInvitation
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<List<InvitationModel>>> getPendingInvitations() {
    // TODO: implement getInvitationHistory
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<InvitationModel>> rejectInvitation(String id) {
    // TODO: implement rejectInvitation
    throw UnimplementedError();
  }
}
