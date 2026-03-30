import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/memberships/domain/usecases/get_members_usecase.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_state.dart';

class MemberListBloc extends Bloc<MemberListEvent, MemberListState> {
  final GetMembersUsecase _getMembersUsecase;

  MemberListBloc(this._getMembersUsecase) : super(const MemberListState()) {
    on<GetMemberListRequested>(_onGetMemberListRequested);
  }

  Future<void> _onGetMemberListRequested(
    GetMemberListRequested event,
    Emitter<MemberListState> emit,
  ) async {
    emit(state.copyWith(status: MemberListStatus.loading));

    final result = await _getMembersUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: MemberListStatus.error,
        errorMessage: failure.message,
      )),
      (members) => emit(state.copyWith(
        status: MemberListStatus.success,
        members: members,
      )),
    );
  }
}