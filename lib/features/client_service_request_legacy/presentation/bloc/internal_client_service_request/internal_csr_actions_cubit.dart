import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/usecases/approve_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/usecases/reject_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';

class InternalCsrActionsCubit extends Cubit<InternalCsrActionsState> {
  final ApproveCsrUsecase _approveCsrUsecase;
  final RejectCsrUsecase _rejectCsrUsecase;

  InternalCsrActionsCubit(this._approveCsrUsecase, this._rejectCsrUsecase)
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

  Future<void> rejectCsr(String id) async {
    emit(state.copyWith(status: CsrStateStatus.loading));
    final result = await _rejectCsrUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CsrStateStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: CsrStateStatus.rejected,
      )),
    );
  }
}
