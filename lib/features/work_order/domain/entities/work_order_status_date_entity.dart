import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';

class WorkOrderStatusDateEntity {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? sentAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? failedAt;

  const WorkOrderStatusDateEntity({
    this.createdAt,
    this.updatedAt,
    this.sentAt,
    this.approvedAt,
    this.rejectedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.failedAt,
  });

  String getDateString(WorkOrderStatus status) {
    DateTime? date;

    switch (status) {
      case WorkOrderStatus.drafted:
        date = createdAt;
        break;

      case WorkOrderStatus.sent:
        date = sentAt;
        break;

      case WorkOrderStatus.approved:
        date = approvedAt;
        break;

      case WorkOrderStatus.rejected:
        date = rejectedAt;
        break;

      case WorkOrderStatus.onProgress:
        date = startedAt;
        break;

      case WorkOrderStatus.completed:
        date = completedAt;
        break;

      case WorkOrderStatus.cancelled:
        date = cancelledAt;
        break;

      case WorkOrderStatus.failed:
        date = failedAt;
        break;
    }

    if (date == null) return '-';
    date = date.toLocal();
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
  }
}
