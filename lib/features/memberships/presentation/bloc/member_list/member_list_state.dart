import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';

enum MemberListStatus {
  initial,
  loading,
  success,
  error,
}

class MemberListState extends Equatable {
  final MemberListStatus status;
  final List<MemberEntity> members;
  final String? errorMessage;

  const MemberListState({
    this.status = MemberListStatus.initial,
    this.members = const [],
    this.errorMessage,
  });

  MemberListState copyWith({
    MemberListStatus? status,
    List<MemberEntity>? members,
    String? errorMessage,
  }) {
    return MemberListState(
      status: status ?? this.status,
      members: members ?? this.members,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        members,
        errorMessage,
      ];
}
