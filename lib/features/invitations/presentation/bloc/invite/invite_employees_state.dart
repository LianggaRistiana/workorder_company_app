import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitation_entity.dart';

enum InviteEmployeesStatus { initial, loading, success, error }

class InviteEmployeesState extends Equatable {
  final InviteEmployeesStatus status;
  final String? errorMessage;
  final List<InvitationEntity> invitationsSuccess;

  const InviteEmployeesState({
    this.status = InviteEmployeesStatus.initial,
    this.errorMessage,
    this.invitationsSuccess = const [],
  });

  InviteEmployeesState copyWith({
    InviteEmployeesStatus? status,
    String? errorMessage,
    List<InvitationEntity>? invitationsSuccess,
  }) {
    return InviteEmployeesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      invitationsSuccess: invitationsSuccess ?? this.invitationsSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        invitationsSuccess,
      ];
}
