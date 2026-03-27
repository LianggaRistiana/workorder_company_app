import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_update_service_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/update/service_update_state.dart';

class ServiceUpdateCubit extends Cubit<ServiceUpdateState> {
  final InternalUpdateServiceUsecase _updateServiceUsecase;

  ServiceUpdateCubit(this._updateServiceUsecase)
      : super(const ServiceUpdateState(status: ServiceUpdateStatus.initial));

  Future<void> submit(ServiceDraft service) async {
    emit(state.copyWith(status: ServiceUpdateStatus.loading));
    final result = await _updateServiceUsecase.call(service);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ServiceUpdateStatus.error,
          errorMessage: failure.message,
        ));
      },
      (service) {
        emit(state.copyWith(
          status: ServiceUpdateStatus.success,
          // service: service,
        ));
      },
    );
  }
}
