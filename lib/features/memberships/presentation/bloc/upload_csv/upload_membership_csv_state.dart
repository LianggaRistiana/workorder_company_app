import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

enum UploadMembershipCsvStatus { initial, loading, success, failure }

class UploadMembershipCsvState extends Equatable {
  final UploadMembershipCsvStatus status;
  final String? errorMessage;
  final List<MembershipCodeEntity> membershipCodes;

  const UploadMembershipCsvState({
    this.status = UploadMembershipCsvStatus.initial,
    this.errorMessage,
    this.membershipCodes = const [],
  });

  UploadMembershipCsvState copyWith({
    UploadMembershipCsvStatus? status,
    String? errorMessage,
    List<MembershipCodeEntity>? membershipCodes,
  }) {
    return UploadMembershipCsvState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      membershipCodes: membershipCodes ?? this.membershipCodes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        membershipCodes,
      ];
}
