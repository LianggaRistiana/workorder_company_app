import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum FinalizeWorkOrderStatus { initial, loading, success, error }

class FinalizeWorkOrderState extends Equatable {
  final FinalizeWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  WorkOrderEntity? get workOrder => result?.data;

  const FinalizeWorkOrderState(
      {required this.status, this.result, this.errorMessage});

  factory FinalizeWorkOrderState.initial() =>
      const FinalizeWorkOrderState(status: FinalizeWorkOrderStatus.initial);

  FinalizeWorkOrderState copyWith(
      {FinalizeWorkOrderStatus? status,
      Result<WorkOrderEntity>? result,
      String? errorMessage}) {
    return FinalizeWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
