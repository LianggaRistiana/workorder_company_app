import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/send_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_state.dart';

class SendWorkOrderCubit extends Cubit<SendWorkOrderState> {
  final SendWorkOrderUseCase useCase;

  SendWorkOrderCubit({required this.useCase})
      : super(SendWorkOrderState.initial());

  Future<void> sendWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: SendWorkOrderStatus.loading));
    final result = await useCase(workOrder);
    result.fold(
      (failure) => emit(state.copyWith(
          status: SendWorkOrderStatus.error, errorMessage: failure.message)),
      (metaResult) => emit(state.copyWith(
          status: SendWorkOrderStatus.success, workOrder: metaResult.data)),
    );
  }
}
