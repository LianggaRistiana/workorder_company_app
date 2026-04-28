import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_state.dart';

class RequesterServiceRequestsListBloc extends Bloc<
    RequesterServiceRequestsListEvent, RequesterServiceRequestsListState> {
  final RequesterGetServiceRequestsUsecase getServiceRequestsUsecase;

  final Stream<void> requesterServiceRequestChangedStream;
  late final StreamSubscription _subscription;

  RequesterServiceRequestsListBloc({
    required this.getServiceRequestsUsecase,
    required this.requesterServiceRequestChangedStream,
  }) : super(const RequesterServiceRequestsListState()) {
    on<GetRequesterServiceRequestsRequested>(
        _onGetRequesterServiceRequestsRequested);
    _subscription = requesterServiceRequestChangedStream.listen((_) {
      add(GetRequesterServiceRequestsRequested());
    });
  }

  Future<void> _onGetRequesterServiceRequestsRequested(
    GetRequesterServiceRequestsRequested event,
    Emitter<RequesterServiceRequestsListState> emit,
  ) async {
    emit(state.copyWith(
        status: RequesterServiceRequestsListStatus.loading,
        errorMessage: null));

    final result =
        await getServiceRequestsUsecase(forceRefresh: event.isRefresh);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterServiceRequestsListStatus.error,
        errorMessage: failure.message,
      )),
      (requests) => emit(state.copyWith(
        status: RequesterServiceRequestsListStatus.loaded,
        requests: requests,
      )),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
