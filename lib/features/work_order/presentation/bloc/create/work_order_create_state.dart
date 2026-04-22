import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum WorkOrderCreateStatus {
  initial,
  loading,
  success,
  error,
}

class WorkOrderCreateState extends Equatable {
  final WorkOrderCreateStatus status;
  final Result<WorkOrderEntity>? result;
  final String? errorMessage;

  const WorkOrderCreateState({
    required this.status,
    this.result,
    this.errorMessage,
  });

  WorkOrderEntity? get workOrder => result?.data;

  WorkOrderCreateState copyWith({
    WorkOrderCreateStatus? status,
    Result<WorkOrderEntity>? result,
    String? errorMessage,
  }) {
    return WorkOrderCreateState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        result,
        errorMessage,
      ];
}
