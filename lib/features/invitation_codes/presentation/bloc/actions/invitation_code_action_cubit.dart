import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_draft_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/create_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/revoke_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/update_invitation_code_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_state.dart';

class InvitationCodeActionCubit
    extends Cubit<InvitationCodeActionState> {
  final CreateInvitationCodeUsecase _createUsecase;
  final UpdateInvitationCodeUsecase _updateUsecase;
  final RevokeInvitationCodeUsecase _revokeUsecase;

  InvitationCodeActionCubit(
    this._createUsecase,
    this._updateUsecase,
    this._revokeUsecase,
  ) : super(const InvitationCodeActionState());

  Future<void> create(InvitationCodeDraftEntity draft) async {
    emit(state.copyWith(status: InvitationCodeActionStatus.loading));

    final result = await _createUsecase(draft);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvitationCodeActionStatus.error,
        errorMessage: failure.message,
      )),
      (code) => emit(state.copyWith(
        status: InvitationCodeActionStatus.success,
        result: code,
      )),
    );
  }

  Future<void> update(String id, InvitationCodeDraftEntity draft) async {
    emit(state.copyWith(status: InvitationCodeActionStatus.loading));

    final result = await _updateUsecase(id, draft);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvitationCodeActionStatus.error,
        errorMessage: failure.message,
      )),
      (code) => emit(state.copyWith(
        status: InvitationCodeActionStatus.success,
        result: code,
      )),
    );
  }

  Future<void> revoke(String id) async {
    emit(state.copyWith(status: InvitationCodeActionStatus.loading));

    final result = await _revokeUsecase(id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvitationCodeActionStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(InvitationCodeActionState(
        status: InvitationCodeActionStatus.success,
        revokedId: id,
      )),
    );
  }
}
