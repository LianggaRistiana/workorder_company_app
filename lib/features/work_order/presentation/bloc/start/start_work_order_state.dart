import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum StartWorkOrderStatus { initial, loading, success, error }

class StartWorkOrderState extends Equatable {
  final StartWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const StartWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory StartWorkOrderState.initial() =>
      const StartWorkOrderState(status: StartWorkOrderStatus.initial);

  StartWorkOrderState copyWith({
    StartWorkOrderStatus? status,
    WorkOrderEntity? workOrder,
    String? errorMessage,
  }) {
    return StartWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
