import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_approve_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_reject_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_state.dart';

class ProviderReviewServiceRequestCubit
    extends Cubit<ProviderActionServiceRequestState> {
  final ProviderApproveServiceRequestUsecase approveServiceRequestUsecase;
  final ProviderRejectServiceRequestUsecase rejectServiceRequestUsecase;

  ProviderReviewServiceRequestCubit({
    required this.approveServiceRequestUsecase,
    required this.rejectServiceRequestUsecase,
  }) : super(const ProviderActionServiceRequestState());

  Future<void> approveServiceRequest(
      ProviderServiceRequestEntity entity) async {
    emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.loading,
        errorMessage: null));

    final result = await approveServiceRequestUsecase(entity);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.success,
        request: request,
      )),
    );
  }

  Future<void> rejectServiceRequest(ProviderServiceRequestEntity entity) async {
    emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.loading,
        errorMessage: null));

    final result = await rejectServiceRequestUsecase(entity);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: ProviderReviewServiceRequestStatus.success,
        request: request,
      )),
    );
  }
}
