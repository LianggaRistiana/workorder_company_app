import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_reject_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/reject_service_request/provider_reject_service_request_state.dart';

class ProviderRejectServiceRequestCubit extends Cubit<ProviderRejectServiceRequestState> {
  final ProviderRejectServiceRequestUsecase rejectServiceRequestUsecase;

  ProviderRejectServiceRequestCubit({
    required this.rejectServiceRequestUsecase,
  }) : super(const ProviderRejectServiceRequestState());

  Future<void> rejectServiceRequest(ProviderServiceRequestEntity entity) async {
    emit(state.copyWith(status: ProviderRejectServiceRequestStatus.loading, errorMessage: null));

    final result = await rejectServiceRequestUsecase(entity);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderRejectServiceRequestStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: ProviderRejectServiceRequestStatus.success,
        request: request,
      )),
    );
  }
}
