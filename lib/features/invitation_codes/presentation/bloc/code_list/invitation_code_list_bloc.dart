import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/usecases/get_invitation_codes_usecase.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_event.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_state.dart';

class InvitationCodeListBloc
    extends Bloc<InvitationCodeListEvent, InvitationCodeListState> {
  final GetInvitationCodesUsecase _usecase;

  InvitationCodeListBloc(this._usecase)
      : super(const InvitationCodeListState()) {
    on<GetInvitationCodeList>(_onGetList);
    on<RemoveInvitationCodeFromList>(_onRemove);
    on<AddInvitationCodeToList>(_onAdd);
    on<UpdateInvitationCodeInList>(_onUpdate);
  }

  Future<void> _onGetList(
    GetInvitationCodeList event,
    Emitter<InvitationCodeListState> emit,
  ) async {
    emit(state.copyWith(status: InvitationCodeListStatus.loading));

    final result = await _usecase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: InvitationCodeListStatus.error,
        errorMessage: failure.message,
      )),
      (codes) => emit(state.copyWith(
        status: InvitationCodeListStatus.loaded,
        codes: codes,
      )),
    );
  }

  void _onRemove(
    RemoveInvitationCodeFromList event,
    Emitter<InvitationCodeListState> emit,
  ) {
    emit(state.copyWith(
      codes: state.codes.where((c) => c.id != event.id).toList(),
    ));
  }

  void _onAdd(
    AddInvitationCodeToList event,
    Emitter<InvitationCodeListState> emit,
  ) {
    if (event.code is InvitationCodeEntity) {
      emit(state.copyWith(
        codes: [event.code as InvitationCodeEntity, ...state.codes],
      ));
    }
  }

  void _onUpdate(
    UpdateInvitationCodeInList event,
    Emitter<InvitationCodeListState> emit,
  ) {
    if (event.code is InvitationCodeEntity) {
      final updated = event.code as InvitationCodeEntity;
      emit(state.copyWith(
        codes: state.codes
            .map((c) => c.id == updated.id ? updated : c)
            .toList(),
      ));
    }
  }
}
