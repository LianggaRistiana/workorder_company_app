import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_approve_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/approve_service_request/provider_approve_service_request_state.dart';

class ProviderApproveServiceRequestCubit extends Cubit<ProviderApproveServiceRequestState> {
  final ProviderApproveServiceRequestUsecase approveServiceRequestUsecase;

  ProviderApproveServiceRequestCubit({
    required this.approveServiceRequestUsecase,
  }) : super(const ProviderApproveServiceRequestState());

  Future<void> approveServiceRequest(ProviderServiceRequestEntity entity) async {
    emit(state.copyWith(status: ProviderApproveServiceRequestStatus.loading, errorMessage: null));

    final result = await approveServiceRequestUsecase(entity);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderApproveServiceRequestStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: ProviderApproveServiceRequestStatus.success,
        request: request,
      )),
    );
  }
}
