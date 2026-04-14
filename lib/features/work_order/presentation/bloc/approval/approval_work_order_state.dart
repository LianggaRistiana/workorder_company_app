import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum ApprovalWorkOrderStatus { initial, loading, success, error }

class ApprovalWorkOrderState extends Equatable {
  final ApprovalWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  WorkOrderEntity? get workOrder => result?.data;

  const ApprovalWorkOrderState(
      {required this.status, this.result, this.errorMessage});

  factory ApprovalWorkOrderState.initial() =>
      const ApprovalWorkOrderState(status: ApprovalWorkOrderStatus.initial);

  ApprovalWorkOrderState copyWith(
      {ApprovalWorkOrderStatus? status,
      Result<WorkOrderEntity>? result,
      String? errorMessage}) {
    return ApprovalWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
