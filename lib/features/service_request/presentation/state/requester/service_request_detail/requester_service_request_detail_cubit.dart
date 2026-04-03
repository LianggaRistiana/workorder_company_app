import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_request_detail_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_state.dart';

class RequesterServiceRequestDetailCubit extends Cubit<RequesterServiceRequestDetailState> {
  final RequesterGetServiceRequestDetailUsecase getServiceRequestDetailUsecase;

  RequesterServiceRequestDetailCubit({
    required this.getServiceRequestDetailUsecase,
  }) : super(const RequesterServiceRequestDetailState());

  Future<void> getServiceRequestDetail(String id) async {
    emit(state.copyWith(status: RequesterServiceRequestDetailStatus.loading, errorMessage: null));

    final result = await getServiceRequestDetailUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: RequesterServiceRequestDetailStatus.error,
        errorMessage: failure.message,
      )),
      (request) => emit(state.copyWith(
        status: RequesterServiceRequestDetailStatus.loaded,
        request: request,
      )),
    );
  }
}
