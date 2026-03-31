import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';

enum PendingInvitationsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class PendingInvitationsListState extends Equatable {
  final PendingInvitationsListStatus status;
  final List<InvitationEntity> invitations;
  final String? errorMessage;

  const PendingInvitationsListState(
      {this.status = PendingInvitationsListStatus.initial,
      this.invitations = const [],
      this.errorMessage});

  PendingInvitationsListState copyWith({
    PendingInvitationsListStatus? status,
    List<InvitationEntity>? invitations,
    String? errorMessage,
  }) {
    return PendingInvitationsListState(
      status: status ?? this.status,
      invitations: invitations ?? this.invitations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        invitations,
        errorMessage,
      ];
}
