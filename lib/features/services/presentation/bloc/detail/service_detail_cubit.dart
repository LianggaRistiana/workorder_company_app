import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_service_byid_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/detail/service_detail_state.dart';

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  final InternalGetServiceByidUsecase internalGetServiceByIdUsecase;

  ServiceDetailCubit({required this.internalGetServiceByIdUsecase})
      : super(ServiceDetailState.initial());

  Future<void> getServiceDetail(String id) async {
    emit(state.copyWith(status: ServiceDetailStatus.loading));

    final result = await internalGetServiceByIdUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceDetailStatus.error,
        errorMessage: failure.message,
      )),
      (service) => emit(state.copyWith(
        status: ServiceDetailStatus.loaded,
        service: service,
      )),
    );
  }

  Future<void> replaceService(ServiceEntity service) async {
    emit(state.copyWith(service: service));
  }
}
