import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';

enum ReceiverInvitationActionsStatus { initial, loading, success, error }

class ReceiverInvitationActionsState {
  ReceiverInvitationActionsStatus status;
  String? errorMessage;
  InvitationEntity? updatedInvitation;

  ReceiverInvitationActionsState({
    this.status = ReceiverInvitationActionsStatus.initial,
    this.errorMessage,
    this.updatedInvitation,
  });
}
