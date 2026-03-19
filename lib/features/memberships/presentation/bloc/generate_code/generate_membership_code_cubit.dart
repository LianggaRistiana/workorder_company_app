import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/generate_membership_codes_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/generate_code/generate_membership_code_state.dart';

class GenerateMembershipCodeCubit extends Cubit<GenerateMembershipCodeState> {
  final GenerateMembershipCodesUsecase _generateMembershipCodesUsecase;

  GenerateMembershipCodeCubit(this._generateMembershipCodesUsecase)
      : super(const GenerateMembershipCodeState());

  Future<void> generateCode(MembershipCodesGenerateDraftEntity draft) async {
    emit(state.copyWith(status: GenerateMembershipCodeStatus.loading));
    final result = await _generateMembershipCodesUsecase(draft);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: GenerateMembershipCodeStatus.error,
          errorMessage: failure.message,
        ));
      },
      (codes) {
        emit(state.copyWith(
          status: GenerateMembershipCodeStatus.success,
        ));
      },
    );
  }
}
