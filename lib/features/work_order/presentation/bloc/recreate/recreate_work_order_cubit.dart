import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/recreate_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_state.dart';

class RecreateWorkOrderCubit extends Cubit<RecreateWorkOrderState> {
  final RecreateWorkOrderUseCase useCase;

  RecreateWorkOrderCubit({required this.useCase})
      : super(RecreateWorkOrderState.initial());

  Future<void> recreateWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: RecreateWorkOrderStatus.loading));
    final result = await useCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: RecreateWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: RecreateWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
