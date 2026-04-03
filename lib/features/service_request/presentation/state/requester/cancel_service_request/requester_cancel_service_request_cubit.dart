import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_cancel_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/cancel_service_request/requester_cancel_service_request_state.dart';

class RequesterCancelServiceRequestCubit extends Cubit<RequesterCancelServiceRequestState> {
  final RequesterCancelServiceRequestUsecase cancelServiceRequestUsecase;

  RequesterCancelServiceRequestCubit({
    required this.cancelServiceRequestUsecase,
  }) : super(const RequesterCancelServiceRequestState());

  Future<void> cancelServiceRequest(String id) async {
    emit(state.copyWith(status: RequesterCancelServiceRequestStatus.loading, errorMessage: null));

    final result = await cancelServiceRequestUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterCancelServiceRequestStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: RequesterCancelServiceRequestStatus.success,
        request: request,
      )),
    );
  }
}
