import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum CancelWorkOrderStatus { initial, loading, success, error }

class CancelWorkOrderState extends Equatable {
  final CancelWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  bool get isLoading => status == CancelWorkOrderStatus.loading;

  const CancelWorkOrderState(
      {required this.status, this.result, this.errorMessage});

  factory CancelWorkOrderState.initial() =>
      const CancelWorkOrderState(status: CancelWorkOrderStatus.initial);

  CancelWorkOrderState copyWith(
      {CancelWorkOrderStatus? status,
      Result<WorkOrderEntity>? result,
      String? errorMessage}) {
    return CancelWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
