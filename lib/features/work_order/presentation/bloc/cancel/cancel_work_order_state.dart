import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum CancelWorkOrderStatus { initial, loading, success, error }

class CancelWorkOrderState extends Equatable {
  final CancelWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const CancelWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory CancelWorkOrderState.initial() =>
      const CancelWorkOrderState(status: CancelWorkOrderStatus.initial);

  CancelWorkOrderState copyWith(
      {CancelWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return CancelWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
