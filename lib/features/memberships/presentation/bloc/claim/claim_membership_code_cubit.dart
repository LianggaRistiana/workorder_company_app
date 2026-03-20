import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/claim_membership_code_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/claim/claim_membership_code_state.dart';

class ClaimMembershipCodeCubit extends Cubit<ClaimMembershipCodeState> {
  final ClaimMembershipCodeUsecase _claimMembershipCode;

  ClaimMembershipCodeCubit(this._claimMembershipCode)
      : super(const ClaimMembershipCodeState());

  Future<void> claim(String code) async {
    emit(state.copyWith(status: ClaimMembershipCodeStatus.loading));

    final result = await _claimMembershipCode(code);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ClaimMembershipCodeStatus.failure,
        errorMessage: failure.message,
      )),
      (company) => emit(state.copyWith(
        status: ClaimMembershipCodeStatus.success,
      )),
    );
  }

  void reset() {
    emit(const ClaimMembershipCodeState());
  }
}
