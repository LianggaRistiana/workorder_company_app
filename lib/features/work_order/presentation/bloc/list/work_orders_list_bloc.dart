import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';

class WorkOrdersListBloc
    extends Bloc<WorkOrdersListEvent, WorkOrdersListState> {
  final GetWorkOrdersUsecase getWorkOrdersUseCase;
  
  final Stream<void> workOrderChangedStream;
  late final StreamSubscription _subscription;

  WorkOrdersListBloc({
    required this.getWorkOrdersUseCase,
    required this.workOrderChangedStream,
  }) : super(const WorkOrdersListState(
          status: WorkOrdersListStatus.initial,
          workOrders: [],
        )) {
    on<GetWorkOrdersRequested>(_onGetWorkOrdersRequested);
    _subscription = workOrderChangedStream.listen((_) {
      add(const GetWorkOrdersRequested(forceRefresh: false));
    });
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

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
