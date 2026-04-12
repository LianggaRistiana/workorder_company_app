import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/fail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fail/fail_work_order_state.dart';

class FailWorkOrderCubit extends Cubit<FailWorkOrderState> {
  final FailWorkOrderUseCase useCase;

  FailWorkOrderCubit({required this.useCase})
      : super(FailWorkOrderState.initial());

  Future<void> failWorkOrder(
      WorkOrderEntity workOrder, String issueNote) async {
    emit(state.copyWith(status: FailWorkOrderStatus.loading));
    final result = await useCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: FailWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: FailWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
