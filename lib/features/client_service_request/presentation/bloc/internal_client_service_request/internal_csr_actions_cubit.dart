import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/approve_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';

class InternalCsrActionsCubit extends Cubit<InternalCsrActionsState> {
  final ApproveCsrUsecase _approveCsrUsecase;
  InternalCsrActionsCubit(this._approveCsrUsecase)
      : super(const InternalCsrActionsState());

  Future<void> approveCsr(String id) async {
    emit(state.copyWith(status: CsrStateStatus.loading));
    final result = await _approveCsrUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CsrStateStatus.error,
        errorMessage: failure.message,
      )),
      (id) => emit(state.copyWith(
        status: CsrStateStatus.loaded,
        workorderId: id,
      )),
    );
  }
}
