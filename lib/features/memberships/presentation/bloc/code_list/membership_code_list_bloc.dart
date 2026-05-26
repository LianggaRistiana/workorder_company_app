import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/get_membership_codes_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_state.dart';

class MembershipCodeListBloc
    extends Bloc<MembershipCodeListEvent, MembershipCodeListState> {
  final GetMembershipCodesUsecase _getMembershipCodesUsecase;

  MembershipCodeListBloc(this._getMembershipCodesUsecase)
      : super(const MembershipCodeListState()) {
    on<GetMembershipCodeListRequested>(_onGetMembershipCodeListRequested);
    on<AddMembershipCodeRequested>(_onGetMemberListRequested);
    on<DeleteMembershipCodeRequested>(_onDeleteMembershipCodeRequested);
  }

  void _onGetMembershipCodeListRequested(
    GetMembershipCodeListRequested event,
    Emitter<MembershipCodeListState> emit,
  ) async {
    emit(state.copyWith(status: MemberShipCodeListStatus.loading));
    final result = await _getMembershipCodesUsecase();
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: MemberShipCodeListStatus.error,
          errorMessage: failure.message,
        ));
      },
      (codes) {
        emit(state.copyWith(
          status: MemberShipCodeListStatus.success,
          codes: codes,
        ));
      },
    );
  }

  void _onGetMemberListRequested(
    AddMembershipCodeRequested event,
    Emitter<MembershipCodeListState> emit,
  ) {
    emit(
      state.copyWith(
        codes: [
          ...state.codes,
          ...event.codes,
        ],
      ),
    );
  }

  void _onDeleteMembershipCodeRequested(
    DeleteMembershipCodeRequested event,
    Emitter<MembershipCodeListState> emit,
  ) {
    emit(
      state.copyWith(
        codes: state.codes.where((element) => element.id != event.id).toList(),
      ),
    );
  }
}
