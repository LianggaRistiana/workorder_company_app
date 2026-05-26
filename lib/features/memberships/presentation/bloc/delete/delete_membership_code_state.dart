import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

enum DeleteMembershipCodeStatus { initial, loading, success, failure }

class DeleteMembershipCodeState extends Equatable {
  final DeleteMembershipCodeStatus status;
  final String? errorMessage;
  final MembershipCodeEntity? deletedCode;
  final MembershipCodeEntity? deletingCode;

  const DeleteMembershipCodeState({
    this.status = DeleteMembershipCodeStatus.initial,
    this.errorMessage,
    this.deletingCode,
    this.deletedCode,
  });

  DeleteMembershipCodeState copyWith({
    DeleteMembershipCodeStatus? status,
    String? errorMessage,
    MembershipCodeEntity? Function()? deletedCode,
    MembershipCodeEntity? Function()? deletingCode,
  }) {
    return DeleteMembershipCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      deletingCode: deletingCode != null ? deletingCode() : this.deletingCode,
      deletedCode: deletedCode != null ? deletedCode() : this.deletedCode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        deletedCode,
        deletingCode,
      ];
}
