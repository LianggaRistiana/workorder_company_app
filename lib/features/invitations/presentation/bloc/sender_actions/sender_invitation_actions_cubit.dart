import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/cancel_invitation_usecase.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/sender_actions/sender_invitation_actions_state.dart';

class SenderInvitationActionsCubit extends Cubit<SenderInvitationActionsState> {
  final CancelInvitationUsecase _cancelInvitationUsecase;

  SenderInvitationActionsCubit(this._cancelInvitationUsecase)
      : super(const SenderInvitationActionsState(null));

  Future<void> cancelInvitation(String id) async {
    emit(state.copyWith(status: SenderInvitationActionsStatus.loading));

    final result = await _cancelInvitationUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SenderInvitationActionsStatus.error,
        errorMessage: failure.message,
      )),
      (invitation) => emit(state.copyWith(
        status: SenderInvitationActionsStatus.success,
        updatedInvitation: invitation,
      )),
    );
  }
}
