import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

enum ClaimMembershipCodeStatus { initial, loading, success, failure }

class ClaimMembershipCodeState {
  final ClaimMembershipCodeStatus status;
  final ExternalUserEntity? externalUser;
  final String? errorMessage;

  const ClaimMembershipCodeState({
    this.status = ClaimMembershipCodeStatus.initial,
    this.externalUser,
    this.errorMessage,
  });

  ClaimMembershipCodeState copyWith({
    ClaimMembershipCodeStatus? status,
    ExternalUserEntity? externalUser,
    String? errorMessage,
  }) {
    return ClaimMembershipCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      externalUser: externalUser ?? this.externalUser,
    );
  }
}
