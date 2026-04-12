import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/reject_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/reject/reject_work_order_state.dart';

class RejectWorkOrderCubit extends Cubit<RejectWorkOrderState> {
  final RejectWorkOrderUseCase useCase;

  RejectWorkOrderCubit({required this.useCase})
      : super(RejectWorkOrderState.initial());

  Future<void> rejectWorkOrder(
      WorkOrderEntity workOrder, String? issueNote) async {
    emit(state.copyWith(status: RejectWorkOrderStatus.loading));
    final result = await useCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: RejectWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: RejectWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
