import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_update_company_usecase.dart';

import 'internal_update_company_state.dart';

class InternalUpdateCompanyCubit extends Cubit<InternalUpdateCompanyState> {
  final InternalUpdateCompanyUsecase _usecase;

  InternalUpdateCompanyCubit(this._usecase)
      : super(const InternalUpdateCompanyState());

  Future<void> submit(CompanyEntity company) async {
    emit(state.copyWith(isSaving: true, error: null));

    final result = await _usecase(company);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSaving: false,
          error: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          isSaving: false,
          success: true,
        ));
      },
    );
  }
}
