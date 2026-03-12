import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/get_invitations_history_usecase.dart';
import 'history_invitations_list_event.dart';
import 'history_invitations_list_state.dart';

class HistoryInvitationsListBloc
    extends Bloc<HistoryInvitationsListEvent, HistoryInvitationsListState> {
  final GetInvitationsHistoryUsecase _usecase;

  HistoryInvitationsListBloc(this._usecase)
      : super(const HistoryInvitationsListState()) {
    on<GetHistoryInvitationsList>(_onGetHistoryInvitationsList);
  }

  Future<void> _onGetHistoryInvitationsList(
    GetHistoryInvitationsList event,
    Emitter<HistoryInvitationsListState> emit,
  ) async {
    emit(state.copyWith(
      status: HistoryInvitationsListStatus.loading,
      errorMessage: null,
    ));

    final result = await _usecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HistoryInvitationsListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: HistoryInvitationsListStatus.loaded,
          invitations: data,
        ),
      ),
    );
  }
}