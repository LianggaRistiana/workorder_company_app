import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum SendWorkOrderStatus { initial, loading, success, error }

class SendWorkOrderState extends Equatable {
  final SendWorkOrderStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const SendWorkOrderState(
      {required this.status, this.workOrder, this.errorMessage});

  factory SendWorkOrderState.initial() =>
      const SendWorkOrderState(status: SendWorkOrderStatus.initial);

  SendWorkOrderState copyWith(
      {SendWorkOrderStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return SendWorkOrderState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
