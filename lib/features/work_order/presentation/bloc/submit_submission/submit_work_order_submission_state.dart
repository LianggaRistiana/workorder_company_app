import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

enum SubmitWorkOrderSubmissionStatus { initial, loading, success, error }

class SubmitWorkOrderSubmissionState extends Equatable {
  final SubmitWorkOrderSubmissionStatus status;
  final WorkOrderEntity? workOrder;
  final String? errorMessage;

  const SubmitWorkOrderSubmissionState(
      {required this.status, this.workOrder, this.errorMessage});

  factory SubmitWorkOrderSubmissionState.initial() =>
      const SubmitWorkOrderSubmissionState(
          status: SubmitWorkOrderSubmissionStatus.initial);

  SubmitWorkOrderSubmissionState copyWith(
      {SubmitWorkOrderSubmissionStatus? status,
      WorkOrderEntity? workOrder,
      String? errorMessage}) {
    return SubmitWorkOrderSubmissionState(
      status: status ?? this.status,
      workOrder: workOrder ?? this.workOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, workOrder, errorMessage];
}
