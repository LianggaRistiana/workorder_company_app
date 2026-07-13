import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';

enum InvitationCodeListStatus { initial, loading, loaded, error }

class InvitationCodeListState extends Equatable {
  final InvitationCodeListStatus status;
  final List<InvitationCodeEntity> codes;
  final String? errorMessage;

  const InvitationCodeListState({
    this.status = InvitationCodeListStatus.initial,
    this.codes = const [],
    this.errorMessage,
  });

  InvitationCodeListState copyWith({
    InvitationCodeListStatus? status,
    List<InvitationCodeEntity>? codes,
    String? errorMessage,
  }) {
    return InvitationCodeListState(
      status: status ?? this.status,
      codes: codes ?? this.codes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, codes, errorMessage];
}
