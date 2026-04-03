import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features_legacy/client_service_request_legacy/domain/usecases/get_csr_usecase.dart';

part 'internal_csr_event.dart';
part 'internal_csr_state.dart';

class InternalCsrBloc extends Bloc<InternalCsrEvent, InternalCsrState> {
  final GetCsrUsecase usecase;
  final AuthBloc authBloc;
  late final StreamSubscription _authSub;

  InternalCsrBloc({required this.usecase, required this.authBloc})
      : super(InternalCsrState(status: CsrStateStatus.initial)) {
    on<GetClientServiceRequestsRequested>(_onCsrRequested);
    _authSub = authBloc.stream.listen((state) {
      if (state is Unauthenticated) {
        // Logger().d("Reset CSR BLOC HERE");P
      }
    });
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    Logger().d("CSR BLOC CLOSED");

    return super.close();
  }

  Future<void> _onCsrRequested(GetClientServiceRequestsRequested event,
      Emitter<InternalCsrState> emit) async {
    // if (state.status != CsrStateStatus.initial) return;
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
