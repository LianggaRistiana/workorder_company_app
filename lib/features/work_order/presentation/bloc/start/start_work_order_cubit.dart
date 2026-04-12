import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/start_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_state.dart';

class StartWorkOrderCubit extends Cubit<StartWorkOrderState> {
  final StartWorkOrderUseCase useCase;

  StartWorkOrderCubit({required this.useCase})
      : super(StartWorkOrderState.initial());

  Future<void> startWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: StartWorkOrderStatus.loading));
    final result = await useCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: StartWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: StartWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
