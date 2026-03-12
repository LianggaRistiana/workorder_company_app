import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitation_entity.dart';

enum HistoryInvitationsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class HistoryInvitationsListState extends Equatable {
  final HistoryInvitationsListStatus status;
  final List<InvitationEntity> invitations;
  final String? errorMessage;

  const HistoryInvitationsListState({
    this.status = HistoryInvitationsListStatus.initial,
    this.invitations = const [],
    this.errorMessage,
  });

  HistoryInvitationsListState copyWith({
    HistoryInvitationsListStatus? status,
    List<InvitationEntity>? invitations,
    String? errorMessage,
  }) {
    return HistoryInvitationsListState(
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
