import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/usecases/invite_employees_usecase.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/invite/invite_employees_state.dart';

class InviteEmployeesCubit extends Cubit<InviteEmployeesState> {
  final InviteEmployeesUsecase _usecase;

  InviteEmployeesCubit(this._usecase) : super(const InviteEmployeesState());

  Future<void> inviteEmployees(
      List<InvitationDraftEntity> invitationsData) async {
    emit(state.copyWith(status: InviteEmployeesStatus.loading));
    final result = await _usecase(invitationsData);

    result.fold(
        (fail) => emit(
              state.copyWith(
                status: InviteEmployeesStatus.error,
                failure: fail,
              ),
            ),
        (data) => emit(
              state.copyWith(
                status: InviteEmployeesStatus.success,
                invitationsSuccess: data,
              ),
            ));
  }
}
