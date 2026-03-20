enum ClaimMembershipCodeStatus { initial, loading, success, failure }

class ClaimMembershipCodeState {
  final ClaimMembershipCodeStatus status;
  final String? errorMessage;

  const ClaimMembershipCodeState({
    this.status = ClaimMembershipCodeStatus.initial,
    this.errorMessage,
  });

  ClaimMembershipCodeState copyWith({
    ClaimMembershipCodeStatus? status,
    String? errorMessage,
  }) {
    return ClaimMembershipCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
