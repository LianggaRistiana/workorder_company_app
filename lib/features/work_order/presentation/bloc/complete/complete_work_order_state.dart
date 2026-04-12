import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum CompleteWorkOrderStatus { initial, loading, success, error }

class CompleteWorkOrderState extends Equatable {
  final CompleteWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const CompleteWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory CompleteWorkOrderState.initial() =>
      const CompleteWorkOrderState(status: CompleteWorkOrderStatus.initial);

  CompleteWorkOrderState copyWith(
      {CompleteWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return CompleteWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
