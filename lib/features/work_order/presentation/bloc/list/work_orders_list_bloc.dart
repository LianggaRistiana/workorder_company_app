import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_event.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_state.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';

class WorkOrdersListBloc
    extends Bloc<WorkOrdersListEvent, WorkOrdersListState> {
  final GetWorkOrdersUsecase getWorkOrdersUseCase;

  final Stream<void> workOrderChangedStream;
  late final StreamSubscription _subscription;

  WorkOrdersListBloc({
    required this.getWorkOrdersUseCase,
    required this.workOrderChangedStream,
  }) : super(WorkOrdersListState(
          filter: WorkOrderParams(
            status: WorkOrderStatusFlowStateX.cancellableStatesList,
          ),
          status: WorkOrdersListStatus.initial,
          workOrders: [],
        )) {
    on<GetWorkOrdersRequested>(_onGetWorkOrdersRequested);
    on<SetWorkOrderFilter>(_onSetFilter);
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

  Future<void> _onSetFilter(
    SetWorkOrderFilter event,
    Emitter<WorkOrdersListState> emit,
  ) async {
    debugPrint(event.params.toString());
    emit(state.copyWith(filter: event.params));
    debugPrint(state.filter.toString());

  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
