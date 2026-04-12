import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum RejectWorkOrderStatus { initial, loading, success, error }

class RejectWorkOrderState extends Equatable {
  final RejectWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const RejectWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory RejectWorkOrderState.initial() =>
      const RejectWorkOrderState(status: RejectWorkOrderStatus.initial);

  RejectWorkOrderState copyWith(
      {RejectWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return RejectWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
