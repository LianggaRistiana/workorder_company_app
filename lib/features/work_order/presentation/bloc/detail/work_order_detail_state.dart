import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';

enum WorkOrderDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class WorkOrderDetailState extends Equatable {
  final WorkOrderDetailStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  WorkOrderEntity? get workOrder => result?.data;
  WorkOrderSiblings? get workOrderSiblings => result?.getMeta<WorkOrderSiblings>();


  const WorkOrderDetailState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  factory WorkOrderDetailState.initial() {
    return const WorkOrderDetailState(
      status: WorkOrderDetailStatus.initial,
    );
  }

  WorkOrderDetailState copyWith({
    WorkOrderDetailStatus? status,
    Result<WorkOrderEntity>? result,
    String? errorMessage,
  }) {
    return WorkOrderDetailState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
