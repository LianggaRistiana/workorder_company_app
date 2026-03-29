import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_remove_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_toggle_active_service_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/action/service_action_state.dart';

class ServiceActionCubit extends Cubit<ServiceActionState> {
  final InternalRemoveServiceUsecase _removeServiceUsecase;
  final InternalToggleActiveServiceUsecase _toggleActiveServiceUsecase;

  ServiceActionCubit(
    this._removeServiceUsecase,
    this._toggleActiveServiceUsecase,
  ) : super(const ServiceActionState(status: ServiceActionStatus.initial));

  Future<void> removeService(String serviceId) async {
    emit(state.copyWith(status: ServiceActionStatus.loading));

    final result = await _removeServiceUsecase.call(serviceId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceActionStatus.error,
        errorMessage: failure.message,
      )),
      (service) => emit(state.copyWith(
        status: ServiceActionStatus.removed,
        updatedService: service,
      )),
    );
  }

  Future<void> toggleActiveStatus(ServiceEntity service) async {
    emit(state.copyWith(status: ServiceActionStatus.loading));

    final result = await _toggleActiveServiceUsecase.call(service);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceActionStatus.error,
        errorMessage: failure.message,
      )),
      (service) => emit(state.copyWith(
        status: ServiceActionStatus.updated,
        updatedService: service,
      )),
    );
  }
}
