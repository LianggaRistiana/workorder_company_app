import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum FailWorkOrderStatus { initial, loading, success, error }

class FailWorkOrderState extends Equatable {
  final FailWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const FailWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory FailWorkOrderState.initial() =>
      const FailWorkOrderState(status: FailWorkOrderStatus.initial);

  FailWorkOrderState copyWith(
      {FailWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return FailWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
