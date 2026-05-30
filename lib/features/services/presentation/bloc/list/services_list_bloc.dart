import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_services_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_state.dart';

class ServicesListBloc extends Bloc<ServicesListEvent, ServicesListState> {
  final InternalGetServicesUsecase internalGetServicesUsecase;

  final Stream<void> serviceChangedStream;
  late final StreamSubscription _subscription;

  ServicesListBloc(
      {required this.internalGetServicesUsecase,
      required this.serviceChangedStream})
      : super(const ServicesListState(
          status: ServicesListStatus.initial,
          services: [],
        )) {
    on<GetServicesRequested>(_onGetServicesRequested);
    on<SetServiceFilterRequested>(_setFilter);

    _subscription = serviceChangedStream.listen((_) {
      add(GetServicesRequested(forceRefresh: false));
    });
  }

  Future<void> _onGetServicesRequested(
    GetServicesRequested event,
    Emitter<ServicesListState> emit,
  ) async {
    emit(
        state.copyWith(status: ServicesListStatus.loading, errorMessage: null));

    final result =
        await internalGetServicesUsecase(forceRefresh: event.forceRefresh);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServicesListStatus.error,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        status: ServicesListStatus.loaded,
        services: services,
      )),
    );
  }

  Future<void> _setFilter(
      SetServiceFilterRequested event, Emitter<ServicesListState> emit) async {
    emit(state.copyWith(filter: event.filter));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
