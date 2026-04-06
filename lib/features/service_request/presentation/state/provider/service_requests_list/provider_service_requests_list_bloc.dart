import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_state.dart';

class ProviderServiceRequestsListBloc
    extends Bloc<ProviderServiceRequestsListEvent, ProviderServiceRequestsListState> {
  final ProviderGetServiceRequestsUsecase getServiceRequestsUsecase;

  ProviderServiceRequestsListBloc({
    required this.getServiceRequestsUsecase,
  }) : super(const ProviderServiceRequestsListState()) {
    on<GetProviderServiceRequestsRequested>(_onGetProviderServiceRequestsRequested);
  }

  Future<void> _onGetProviderServiceRequestsRequested(
    GetProviderServiceRequestsRequested event,
    Emitter<ProviderServiceRequestsListState> emit,
  ) async {
    emit(state.copyWith(status: ProviderServiceRequestsListStatus.loading, errorMessage: null));

    final result = await getServiceRequestsUsecase();

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
}
