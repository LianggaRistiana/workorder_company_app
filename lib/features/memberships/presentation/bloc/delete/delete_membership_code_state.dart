import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

enum DeleteMembershipCodeStatus { initial, loading, success, failure }

class DeleteMembershipCodeState extends Equatable {
  final DeleteMembershipCodeStatus status;
  final String? errorMessage;
  final MembershipCodeEntity? deletedCode;

  const DeleteMembershipCodeState({
    this.status = DeleteMembershipCodeStatus.initial,
    this.errorMessage,
    this.deletedCode,
  });

  DeleteMembershipCodeState copyWith({
    DeleteMembershipCodeStatus? status,
    String? errorMessage,
    MembershipCodeEntity? deletedCode,
  }) {
    return DeleteMembershipCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      deletedCode: deletedCode ?? this.deletedCode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        deletedCode,
      ];
}
