import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';

enum InvitationCodeActionStatus { initial, loading, success, error }

class InvitationCodeActionState extends Equatable {
  final InvitationCodeActionStatus status;
  final InvitationCodeEntity? result;
  final String? revokedId;
  final String? errorMessage;

  const InvitationCodeActionState({
    this.status = InvitationCodeActionStatus.initial,
    this.result,
    this.revokedId,
    this.errorMessage,
  });

  InvitationCodeActionState copyWith({
    InvitationCodeActionStatus? status,
    InvitationCodeEntity? result,
    String? revokedId,
    String? errorMessage,
  }) {
    return InvitationCodeActionState(
      status: status ?? this.status,
      result: result ?? this.result,
      revokedId: revokedId ?? this.revokedId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, revokedId, errorMessage];
}
