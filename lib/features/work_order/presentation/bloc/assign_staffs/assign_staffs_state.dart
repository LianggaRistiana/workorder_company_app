import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum AssignStaffsStatus { initial, loading, success, error }

class AssignStaffsState extends Equatable {
  final AssignStaffsStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const AssignStaffsState(
      {required this.status, this.workOrder, this.errorMessage});

  factory AssignStaffsState.initial() =>
      const AssignStaffsState(status: AssignStaffsStatus.initial);

  AssignStaffsState copyWith(
      {AssignStaffsStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return AssignStaffsState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
