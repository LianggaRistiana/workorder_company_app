import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/complete_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/complete/complete_work_order_state.dart';

class CompleteWorkOrderCubit extends Cubit<CompleteWorkOrderState> {
  final CompleteWorkOrderUseCase useCase;

  CompleteWorkOrderCubit({required this.useCase})
      : super(CompleteWorkOrderState.initial());

  Future<void> completeWorkOrder(
      WorkOrderEntity workOrder, String? issueNote) async {
    emit(state.copyWith(status: CompleteWorkOrderStatus.loading));
    final result = await useCase(workOrder, issueNote);
    result.fold(
      (failure) => emit(state.copyWith(
          status: CompleteWorkOrderStatus.error,
          errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: CompleteWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
