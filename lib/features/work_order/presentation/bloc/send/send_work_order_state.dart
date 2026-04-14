import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum SendWorkOrderStatus { initial, loading, success, error }

class SendWorkOrderState extends Equatable {
  final SendWorkOrderStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  const SendWorkOrderState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  factory SendWorkOrderState.initial() {
    return const SendWorkOrderState(
      status: SendWorkOrderStatus.initial,
    );
  }

  SendWorkOrderState copyWith({
    SendWorkOrderStatus? status,
    Result<WorkOrderEntity>? result,
    String? errorMessage,
  }) {
    return SendWorkOrderState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
