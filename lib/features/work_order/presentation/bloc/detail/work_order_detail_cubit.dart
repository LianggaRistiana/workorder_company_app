import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_detail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_state.dart';

class WorkOrderDetailCubit extends Cubit<WorkOrderDetailState> {
  final GetDetailWorkOrderUsecase getDetailWorkOrderUseCase;

  WorkOrderDetailCubit({required this.getDetailWorkOrderUseCase})
      : super(WorkOrderDetailState.initial());

  Future<void> getWorkOrderDetail(String id) async {
    emit(state.copyWith(status: WorkOrderDetailStatus.loading));

    final result = await getDetailWorkOrderUseCase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: WorkOrderDetailStatus.error,
        errorMessage: failure.message,
      )),
      (metaResult) => emit(state.copyWith(
          status: WorkOrderDetailStatus.loaded,
          workOrder: metaResult.data,
          siblings: metaResult.getMeta<WorkOrderSiblings>())),
    );
  }

  Future<void> replaceWorkOrder(WorkOrderEntity workOrder) async {
    emit(state.copyWith(workOrder: workOrder));
  }
}
