import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum ApproveWorkOrderStatus { initial, loading, success, error }

class ApproveWorkOrderState extends Equatable {
  final ApproveWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const ApproveWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory ApproveWorkOrderState.initial() =>
      const ApproveWorkOrderState(status: ApproveWorkOrderStatus.initial);

  ApproveWorkOrderState copyWith(
      {ApproveWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return ApproveWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
