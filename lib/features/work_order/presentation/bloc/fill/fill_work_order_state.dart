import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum FillWorkOrderStatus { initial, loading, success, error }

class FillWorkOrderState extends Equatable {
  final FillWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  WorkOrderEntity? get workOrder => result?.data;

  const FillWorkOrderState(
      {required this.status, this.result, this.errorMessage});

  factory FillWorkOrderState.initial() =>
      const FillWorkOrderState(status: FillWorkOrderStatus.initial);

  FillWorkOrderState copyWith(
      {FillWorkOrderStatus? status,
      Result<WorkOrderEntity>? result,
      String? errorMessage}) {
    return FillWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
