import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/create_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/create/work_order_create_state.dart';

class WorkOrderCreateCubit extends Cubit<WorkOrderCreateState> {
  final CreateWorkOrderUsecase createWorkOrderUsecase;

  WorkOrderCreateCubit({required this.createWorkOrderUsecase})
      : super(
            const WorkOrderCreateState(status: WorkOrderCreateStatus.initial));

  Future<void> createWorkOrder(String serviceId) async {
    emit(state.copyWith(status: WorkOrderCreateStatus.loading));

    final result = await createWorkOrderUsecase(serviceId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: WorkOrderCreateStatus.error,
        errorMessage: failure.message,
      )),
      (successResult) => emit(state.copyWith(
        status: WorkOrderCreateStatus.success,
        errorMessage: null,
        result: successResult,
      )),
    );
  }
}
