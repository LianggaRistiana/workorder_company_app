import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/claim_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/preview_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/claim/claim_invitation_code_state.dart';

class ClaimInvitationCodeCubit extends Cubit<ClaimInvitationCodeState> {
  final PreviewInvitationCodeUsecase _previewUsecase;
  final ClaimInvitationCodeUsecase _claimUsecase;

  ClaimInvitationCodeCubit(this._previewUsecase, this._claimUsecase)
      : super(const ClaimInvitationCodeState());

  Future<void> preview(String code) async {
    emit(state.copyWith(status: ClaimInvitationCodeStatus.previewing));

    final result = await _previewUsecase(code.trim().toUpperCase());
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClaimInvitationCodeStatus.error,
        errorMessage: failure.message,
      )),
      (preview) => emit(ClaimInvitationCodeState(
        status: ClaimInvitationCodeStatus.previewed,
        preview: preview,
      )),
    );
  }

  Future<void> claim(String code) async {
    emit(state.copyWith(status: ClaimInvitationCodeStatus.claiming));

    final result = await _claimUsecase(code.trim().toUpperCase());
    result.fold(
      (failure) => emit(state.copyWith(
        status: ClaimInvitationCodeStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ClaimInvitationCodeStatus.claimed)),
    );
  }

  void reset() => emit(const ClaimInvitationCodeState());
}
