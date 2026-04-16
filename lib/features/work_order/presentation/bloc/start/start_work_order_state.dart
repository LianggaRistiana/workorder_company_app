import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum StartWorkOrderStatus { initial, loading, success, error }

class StartWorkOrderState extends Equatable {
  final StartWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  const StartWorkOrderState(
      {required this.status, this.result, this.errorMessage});

  factory StartWorkOrderState.initial() =>
      const StartWorkOrderState(status: StartWorkOrderStatus.initial);

  StartWorkOrderState copyWith({
    StartWorkOrderStatus? status,
    Result<WorkOrderEntity>? result,
    String? errorMessage,
  }) {
    return StartWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
