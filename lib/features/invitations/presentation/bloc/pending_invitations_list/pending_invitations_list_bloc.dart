import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/get_invitations_pending_usecase.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/pending_invitations_list/pending_invitations_list_event.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/pending_invitations_list/pending_invitations_list_state.dart';

class PendingInvitationsListBloc
    extends Bloc<PendingInvitationsListEvent, PendingInvitationsListState> {
  final GetInvitationsPendingUsecase _usecase;

  PendingInvitationsListBloc(this._usecase)
      : super(PendingInvitationsListState()) {
    on<GetPendingInvitationsList>(_onGetPendingInvitationsList);
  }

  Future<void> _onGetPendingInvitationsList(
    GetPendingInvitationsList event,
    Emitter<PendingInvitationsListState> emit,
  ) async {
    emit(state.copyWith(
      status: PendingInvitationsListStatus.loading,
      errorMessage: null,
    ));

    final result = await _usecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PendingInvitationsListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: PendingInvitationsListStatus.loaded,
          invitations: data,
        ),
      ),
    );
  }
}
