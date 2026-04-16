import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/cancel_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_state.dart';

class CancelWorkOrderCubit extends Cubit<CancelWorkOrderState> {
  final CancelWorkOrderUseCase useCase;

  CancelWorkOrderCubit({required this.useCase})
      : super(CancelWorkOrderState.initial());

  Future<void> cancelWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: CancelWorkOrderStatus.loading));
    final result = await useCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: CancelWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: CancelWorkOrderStatus.success, result: metaResult)),
    );
  }
}
