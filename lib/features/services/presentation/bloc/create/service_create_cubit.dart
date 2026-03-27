import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_create_service_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';

class ServiceCreateCubit extends Cubit<ServiceCreateState> {
  final InternalCreateServiceUsecase _createServiceUsecase;

  ServiceCreateCubit(this._createServiceUsecase)
      : super(const ServiceCreateState(status: ServiceCreateStatus.initial));

  Future<void> submit(ServiceDraft service) async {
    emit(state.copyWith(status: ServiceCreateStatus.loading));
    final result = await _createServiceUsecase.call(service);
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ServiceCreateStatus.error,
          errorMessage: failure.message,
        ));
      },
      (service) {
        emit(state.copyWith(
          status: ServiceCreateStatus.success,
          // service: service,
        ));
      },
    );
  }
}
