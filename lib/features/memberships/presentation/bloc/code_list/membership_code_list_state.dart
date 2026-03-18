import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

enum MemberShipCodeListStatus {
  initial,
  loading,
  success,
  error,
}

class MembershipCodeListState extends Equatable {
  final MemberShipCodeListStatus status;
  final List<MembershipCodeEntity> codes;
  final String? errorMessage;

  const MembershipCodeListState({
    this.status = MemberShipCodeListStatus.initial,
    this.codes = const [],
    this.errorMessage,
  });

  MembershipCodeListState copyWith({
    MemberShipCodeListStatus? status,
    List<MembershipCodeEntity>? codes,
    String? errorMessage,
  }) {
    return MembershipCodeListState(
      status: status ?? this.status,
      codes: codes ?? this.codes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        codes,
        errorMessage,
      ];
}
