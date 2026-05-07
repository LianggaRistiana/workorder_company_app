import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';

enum InviteEmployeesStatus { initial, loading, success, error }

class InviteEmployeesState extends Equatable {
  final InviteEmployeesStatus status;
  final Failure? failure;
  final List<InvitationEntity> invitationsSuccess;

  // HACK : temp solution for show the error from validation error
  String? get errorMessage {
    if (failure is ValidationFailure) {
      return (failure as ValidationFailure).mergedErrorValue();
    }
    return failure?.message;
  }

  const InviteEmployeesState({
    this.status = InviteEmployeesStatus.initial,
    this.failure,
    this.invitationsSuccess = const [],
  });

  InviteEmployeesState copyWith({
    InviteEmployeesStatus? status,
    Failure? failure,
    List<InvitationEntity>? invitationsSuccess,
  }) {
    return InviteEmployeesState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      invitationsSuccess: invitationsSuccess ?? this.invitationsSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        failure,
        invitationsSuccess,
      ];
}
