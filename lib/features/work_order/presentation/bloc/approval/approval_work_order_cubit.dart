import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/approve_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/reject_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_state.dart';

class ApprovalWorkOrderCubit extends Cubit<ApprovalWorkOrderState> {
  final ApproveWorkOrderUseCase approveUseCase;
  final RejectWorkOrderUseCase rejectUseCase;

  ApprovalWorkOrderCubit({
    required this.approveUseCase,
    required this.rejectUseCase,
  }) : super(ApprovalWorkOrderState.initial());

  Future<void> approveWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: ApprovalWorkOrderStatus.loading));
    final result = await approveUseCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ApprovalWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: ApprovalWorkOrderStatus.approved, result: metaResult)),
    );
  }

  Future<void> rejectWorkOrder(
      WorkOrderEntity workOrder, String? issueNote) async {
    emit(state.copyWith(status: ApprovalWorkOrderStatus.loading));
    final result = await rejectUseCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ApprovalWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: ApprovalWorkOrderStatus.rejected, result: metaResult)),
    );
  }
}
