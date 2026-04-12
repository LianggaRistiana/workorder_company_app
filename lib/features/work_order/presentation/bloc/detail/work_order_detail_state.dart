import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum WorkOrderDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class WorkOrderDetailState extends Equatable {
  final WorkOrderDetailStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const WorkOrderDetailState({
    required this.status,
    this.workOrder,
    this.errorMessage,
  });

  factory WorkOrderDetailState.initial() {
    return const WorkOrderDetailState(
      status: WorkOrderDetailStatus.initial,
    );
  }

  WorkOrderDetailState copyWith({
    WorkOrderDetailStatus? status,
    WorkOrderEntity? workOrder,
    String? errorMessage,
  }) {
    return WorkOrderDetailState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
