import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/delete_membership_code_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/delete/delete_membership_code_state.dart';

class DeleteMembershipCodeCubit extends Cubit<DeleteMembershipCodeState> {
  final DeleteMembershipCodeUsecase _deleteMembershipCode;

  DeleteMembershipCodeCubit(this._deleteMembershipCode)
      : super(const DeleteMembershipCodeState());

  Future<void> delete(String id) async {
    emit(state.copyWith(status: DeleteMembershipCodeStatus.loading));

    final result = await _deleteMembershipCode(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: DeleteMembershipCodeStatus.failure,
        errorMessage: failure.message,
      )),
      (deletedCode) => emit(state.copyWith(
        status: DeleteMembershipCodeStatus.success,
        deletedCode: deletedCode,
      )),
    );
  }

  void reset() {
    emit(const DeleteMembershipCodeState());
  }
}
