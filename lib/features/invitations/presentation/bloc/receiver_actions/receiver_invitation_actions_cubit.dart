import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/accept_invitation_usecase.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/reject_invitation_usecase.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_state.dart';

class ReceiverInvitationActionsCubit
    extends Cubit<ReceiverInvitationActionsState> {
  final AcceptInvitationUsecase _acceptInvitationUsecase;
  final RejectInvitationUsecase _rejectInvitationUsecase;

  ReceiverInvitationActionsCubit(
    this._acceptInvitationUsecase,
    this._rejectInvitationUsecase,
  ) : super(ReceiverInvitationActionsState());

  Future<void> acceptInvitation(String id) async {
    emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.loading));

    final result = await _acceptInvitationUsecase(id);

    result.fold(
      (failure) => emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.error,
        errorMessage: failure.message,
      )),
      (invitation) => emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.success,
        updatedInvitation: invitation,
        action: ActionType.accept,
      )),
    );
  }

  Future<void> rejectInvitation(String id) async {
    emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.loading));

    final result = await _rejectInvitationUsecase(id);

    result.fold(
      (failure) => emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.error,
        errorMessage: failure.message,
      )),
      (invitation) => emit(ReceiverInvitationActionsState(
        status: ReceiverInvitationActionsStatus.success,
        action: ActionType.reject,
        updatedInvitation: invitation,
      )),
    );
  }
}
