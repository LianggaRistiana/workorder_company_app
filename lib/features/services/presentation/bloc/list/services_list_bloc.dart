import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_services_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_state.dart';

class ServicesListBloc extends Bloc<ServicesListEvent, ServicesListState> {
  final InternalGetServicesUsecase internalGetServicesUsecase;

  ServicesListBloc({required this.internalGetServicesUsecase})
      : super(const ServicesListState(
          status: ServicesListStatus.initial,
          services: [],
        )) {
    on<GetServicesRequested>(_onGetServicesRequested);
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
}
