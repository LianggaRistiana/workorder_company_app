import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/delete_membership_code_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/delete/delete_membership_code_state.dart';

class DeleteMembershipCodeCubit extends Cubit<DeleteMembershipCodeState> {
  final DeleteMembershipCodeUsecase _deleteMembershipCode;

  DeleteMembershipCodeCubit(this._deleteMembershipCode)
      : super(const DeleteMembershipCodeState());

  Future<void> delete(MembershipCodeEntity code) async {
    emit(
      state.copyWith(
        status: DeleteMembershipCodeStatus.loading,
        deletingCode: () => code,
        errorMessage: null,
      ),
    );

    final result = await _deleteMembershipCode(code.id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DeleteMembershipCodeStatus.failure,
            errorMessage: failure.message,
            deletingCode: () => null,
          ),
        );
      },
      (deletedCode) {
        emit(
          state.copyWith(
            status: DeleteMembershipCodeStatus.success,
            deletedCode: () => deletedCode,
            deletingCode: () => null,
          ),
        );
      },
    );
  }

  void reset() {
    emit(const DeleteMembershipCodeState());
  }
}
