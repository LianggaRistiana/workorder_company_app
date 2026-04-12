import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum RecreateWorkOrderStatus { initial, loading, success, error }

class RecreateWorkOrderState extends Equatable {
  final RecreateWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const RecreateWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory RecreateWorkOrderState.initial() =>
      const RecreateWorkOrderState(status: RecreateWorkOrderStatus.initial);

  RecreateWorkOrderState copyWith(
      {RecreateWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return RecreateWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
