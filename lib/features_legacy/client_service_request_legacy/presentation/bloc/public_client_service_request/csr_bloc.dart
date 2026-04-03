import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/domain/usecases/public_get_csr_usecase.dart';

part 'csr_state.dart';
part 'csr_event.dart';

class CsrBloc extends Bloc<CsrEvent, CsrState> {
  final PublicGetCsrUsecase publicGetCsrUsecase;

  CsrBloc({
    required this.publicGetCsrUsecase,
  }) : super(CsrState(status: CsrStateStatus.initial)) {
    on<GetClientServiceRequestsRequested>(_onCsrRequested);
  }

  Future<void> _onCsrRequested(
    GetClientServiceRequestsRequested event,
    Emitter<CsrState> emit,
  ) async {
    emit(state.copyWith(status: CsrStateStatus.loading));
    final result = await publicGetCsrUsecase();

    result.fold(
        (failure) => {
              emit(state.copyWith(
                status: CsrStateStatus.error,
                errorMessage: failure.message,
              )),
            },
        (listCsr) => {
              emit(state.copyWith(
                status: CsrStateStatus.loaded,
                clientServiceRequests: listCsr,
              )),
            });
  }
}
