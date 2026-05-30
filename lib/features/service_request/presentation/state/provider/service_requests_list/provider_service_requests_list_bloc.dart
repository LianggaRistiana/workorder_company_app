import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_state.dart';

class ProviderServiceRequestsListBloc extends Bloc<
    ProviderServiceRequestsListEvent, ProviderServiceRequestsListState> {
  final ProviderGetServiceRequestsUsecase getServiceRequestsUsecase;

  final Stream<void> providerRepoStream;
  late final StreamSubscription _subscription;

  ProviderServiceRequestsListBloc({
    required this.getServiceRequestsUsecase,
    required this.providerRepoStream,
  }) : super(const ProviderServiceRequestsListState()) {
    on<GetProviderServiceRequestsRequested>(
        _onGetProviderServiceRequestsRequested);
    on<SetServiceRequestFilter>(_onSetFilter);
    _subscription = providerRepoStream.listen((_) {
      add(GetProviderServiceRequestsRequested());
    });
  }

  Future<void> _onGetProviderServiceRequestsRequested(
    GetProviderServiceRequestsRequested event,
    Emitter<ProviderServiceRequestsListState> emit,
  ) async {
    emit(state.copyWith(
        status: ProviderServiceRequestsListStatus.loading, errorMessage: null));

    final result =
        await getServiceRequestsUsecase(forceRefresh: event.forceRefresh);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderServiceRequestsListStatus.error,
        errorMessage: failure.message,
      )),
      (requests) => emit(state.copyWith(
        status: ProviderServiceRequestsListStatus.loaded,
        requests: requests,
      )),
    );
  }

  Future<void> _onSetFilter(
    SetServiceRequestFilter event,
    Emitter<ProviderServiceRequestsListState> emit,
  ) async {
    debugPrint("${state.filter.activeFilterCount.toString()} ${state.filter.toString()}" );
    emit(state.copyWith(filter: event.params));
    debugPrint("${state.filter.activeFilterCount.toString()} ${state.filter.toString()}" );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
