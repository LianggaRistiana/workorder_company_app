import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';

class WorkOrdersListBloc
    extends Bloc<WorkOrdersListEvent, WorkOrdersListState> {
  final GetWorkOrdersUsecase getWorkOrdersUseCase;

  WorkOrdersListBloc({required this.getWorkOrdersUseCase})
      : super(const WorkOrdersListState(
          status: WorkOrdersListStatus.initial,
          workOrders: [],
        )) {
    on<GetWorkOrdersRequested>(_onGetWorkOrdersRequested);
  }

  Future<void> _onGetWorkOrdersRequested(
    GetWorkOrdersRequested event,
    Emitter<WorkOrdersListState> emit,
  ) async {
    emit(state.copyWith(
        status: WorkOrdersListStatus.loading, errorMessage: null));

    final result = await getWorkOrdersUseCase(forceRefresh: event.forceRefresh);

    result.fold(
      (failure) => emit(state.copyWith(
        status: WorkOrdersListStatus.error,
        errorMessage: failure.message,
      )),
      (workOrders) => emit(state.copyWith(
        status: WorkOrdersListStatus.loaded,
        workOrders: workOrders,
      )),
    );
  }
}
