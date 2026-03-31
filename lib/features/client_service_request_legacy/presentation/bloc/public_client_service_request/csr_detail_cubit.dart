import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/usecases/public_get_detail_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/public_client_service_request/csr_bloc.dart';

class CsrDetailCubit extends Cubit<CsrDetailState> {
  final PublicGetDetailCsrUsecase _publicGetDetailCsrUsecase;

  CsrDetailCubit(this._publicGetDetailCsrUsecase)
      : super(const CsrDetailState());

  Future<void> getCsrDetail(String id) async {
    emit(state.copyWith(status: CsrStateStatus.loading));

    final data = await _publicGetDetailCsrUsecase(id);
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
