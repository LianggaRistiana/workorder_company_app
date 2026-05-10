import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';

class ServiceRequestStatsEntity extends Equatable {
  final double receivedCount;
  final double cancelledCount;
  final double rejectedCount;
  final double approvedCount;
  final double onProgressCount;
  final double unProcessableCount;
  final double completedCount;
  final double partiallyCompletedCount;
  final double closedCount;
  final double totalCount;

  const ServiceRequestStatsEntity({
    required this.totalCount,
    required this.receivedCount,
    required this.cancelledCount,
    required this.rejectedCount,
    required this.approvedCount,
    required this.onProgressCount,
    required this.unProcessableCount,
    required this.completedCount,
    required this.partiallyCompletedCount,
    required this.closedCount,
  });

  double countByStatus(ServiceRequestStatus status) {
    return switch (status) {
      ServiceRequestStatus.received => receivedCount,
      ServiceRequestStatus.cancelled => cancelledCount,
      ServiceRequestStatus.rejected => rejectedCount,
      ServiceRequestStatus.approved => approvedCount,
      ServiceRequestStatus.onProgress => onProgressCount,
      ServiceRequestStatus.unProcessable => unProcessableCount,
      ServiceRequestStatus.completed => completedCount,
      ServiceRequestStatus.partiallyCompleted => partiallyCompletedCount,
      ServiceRequestStatus.closed => closedCount,
    };
  }

  @override
  List<Object?> get props => [
        totalCount,
        receivedCount,
        cancelledCount,
        rejectedCount,
        approvedCount,
        onProgressCount,
        unProcessableCount,
        completedCount,
        partiallyCompletedCount,
        closedCount,
      ];
}
