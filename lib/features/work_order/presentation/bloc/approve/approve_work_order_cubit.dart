import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/approve_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approve/approve_work_order_state.dart';

class ApproveWorkOrderCubit extends Cubit<ApproveWorkOrderState> {
  final ApproveWorkOrderUseCase useCase;

  ApproveWorkOrderCubit({required this.useCase})
      : super(ApproveWorkOrderState.initial());

  Future<void> approveWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: ApproveWorkOrderStatus.loading));
    final result = await useCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ApproveWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: ApproveWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
