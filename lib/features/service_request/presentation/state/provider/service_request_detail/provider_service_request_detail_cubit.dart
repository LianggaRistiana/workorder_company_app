import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_get_service_request_detail_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_state.dart';

class ProviderServiceRequestDetailCubit extends Cubit<ProviderServiceRequestDetailState> {
  final ProviderGetServiceRequestDetailUsecase getServiceRequestDetailUsecase;

  ProviderServiceRequestDetailCubit({
    required this.getServiceRequestDetailUsecase,
  }) : super(const ProviderServiceRequestDetailState());

  Future<void> getServiceRequestDetail(String id) async {
    emit(state.copyWith(status: ProviderServiceRequestDetailStatus.loading, errorMessage: null));

    final result = await getServiceRequestDetailUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderServiceRequestDetailStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: ProviderServiceRequestDetailStatus.loaded,
        request: request,
      )),
    );
  }
}
