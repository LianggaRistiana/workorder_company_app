import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/get_csr_detail_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';

class InternalCsrDetailCubit extends Cubit<InternalCsrDetailState> {
  final GetCsrDetailUsecase _getCsrDetailUsecase;

  InternalCsrDetailCubit(this._getCsrDetailUsecase)
      : super(const InternalCsrDetailState());

  Future<void> getCsrDetail(String id) async {
    emit(state.copyWith(status: CsrStateStatus.loading));

    final data = await _getCsrDetailUsecase(id);
    data.fold(
      (failure) => emit(
        state.copyWith(
          status: CsrStateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (csr) => emit(
        state.copyWith(
          status: CsrStateStatus.loaded,
          clientServiceRequest: csr,
        ),
      ),
    );
  }
}
