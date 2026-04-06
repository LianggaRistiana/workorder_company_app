import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_get_company_usecase.dart';
import 'internal_company_get_state.dart';

class InternalGetCompanyCubit extends Cubit<InternalGetCompanyState> {
  final InternalGetCompanyUsecase _usecase;

  InternalGetCompanyCubit(this._usecase) : super(const InternalGetCompanyState());

  Future<void> loadCompany() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _usecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.message,
        ));
      },
      (data) {
        emit(state.copyWith(
          company: data,
          isLoading: false,
        ));
      },
    );
  }
}
