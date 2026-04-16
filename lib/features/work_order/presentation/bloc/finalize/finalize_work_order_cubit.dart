import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/complete_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/fail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_state.dart';

class FinalizeWorkOrderCubit extends Cubit<FinalizeWorkOrderState> {
  final CompleteWorkOrderUseCase completeUseCase;
  final FailWorkOrderUseCase failUseCase;

  FinalizeWorkOrderCubit({
    required this.completeUseCase,
    required this.failUseCase,
  }) : super(FinalizeWorkOrderState.initial());

  Future<void> completeWorkOrder(
      WorkOrderEntity workOrder, String? issueNote) async {
    emit(state.copyWith(status: FinalizeWorkOrderStatus.loading));
    final result = await completeUseCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: FinalizeWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: FinalizeWorkOrderStatus.complete, result: metaResult)),
    );
  }

  Future<void> failWorkOrder(
      WorkOrderEntity workOrder, String issueNote) async {
    emit(state.copyWith(status: FinalizeWorkOrderStatus.loading));
    final result = await failUseCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: FinalizeWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: FinalizeWorkOrderStatus.fail, result: metaResult)),
    );
  }
}
