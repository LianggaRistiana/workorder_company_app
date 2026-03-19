import 'package:equatable/equatable.dart';

enum GenerateMembershipCodeStatus { initial, loading, success, error }

class GenerateMembershipCodeState extends Equatable {
  final GenerateMembershipCodeStatus status;
  final String? errorMessage;

  const GenerateMembershipCodeState({
    this.status = GenerateMembershipCodeStatus.initial,
    this.errorMessage,
  });

  GenerateMembershipCodeState copyWith({
    GenerateMembershipCodeStatus? status,
    String? code,
    String? errorMessage,
  }) {
    return GenerateMembershipCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
