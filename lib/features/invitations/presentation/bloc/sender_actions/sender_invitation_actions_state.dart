import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';

enum SenderInvitationActionsStatus {
  initial,
  loading,
  success,
  error,
}

class SenderInvitationActionsState extends Equatable {
  final SenderInvitationActionsStatus status;
  final String? errorMessage;
  final InvitationEntity? updatedInvitation;

  const SenderInvitationActionsState(
    this.updatedInvitation, {
    this.status = SenderInvitationActionsStatus.initial,
    this.errorMessage,
  });
  SenderInvitationActionsState copyWith({
    InvitationEntity? updatedInvitation,
    SenderInvitationActionsStatus? status,
    String? errorMessage,
  }) {
    return SenderInvitationActionsState(
      updatedInvitation ?? this.updatedInvitation,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        updatedInvitation,
        status,
        errorMessage,
      ];
} 
