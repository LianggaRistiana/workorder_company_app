import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum WorkOrdersListStatus {
  initial,
  loading,
  loaded,
  error,
}

class WorkOrdersListState extends Equatable {
  final WorkOrdersListStatus status;
  final List<WorkOrderEntity> workOrders;
  final String? errorMessage;

  const WorkOrdersListState({
    required this.status,
    required this.workOrders,
    this.errorMessage,
  });

  WorkOrdersListState copyWith({
    WorkOrdersListStatus? status,
    List<WorkOrderEntity>? workOrders,
    String? errorMessage,
  }) {
    return WorkOrdersListState(
      status: status ?? this.status,
      workOrders: workOrders ?? this.workOrders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrders, errorMessage];
}
