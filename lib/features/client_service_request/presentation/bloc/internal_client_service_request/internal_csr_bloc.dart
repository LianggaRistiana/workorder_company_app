import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/get_csr_usecase.dart';

part 'internal_csr_event.dart';
part 'internal_csr_state.dart';

class InternalCsrBloc extends Bloc<InternalCsrEvent, InternalCsrState> {
  final GetCsrUsecase usecase;

  InternalCsrBloc({required this.usecase})
      : super(InternalCsrState(status: CsrStateStatus.initial)) {
    on<GetClientServiceRequestsRequested>(_onCsrRequested);
  }

  Future<void> _onCsrRequested(GetClientServiceRequestsRequested event,
      Emitter<InternalCsrState> emit) async {
    emit(state.copyWith(status: CsrStateStatus.loading));
    final result = await usecase();

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
