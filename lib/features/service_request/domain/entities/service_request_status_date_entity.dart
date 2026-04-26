import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';

class ServiceRequestStatusDateEntity {
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? onProgressAt;
  final DateTime? completedAt;
  final DateTime? unProcessableAt;
  final DateTime? closedAt;
  final DateTime? cancelledAt;
  final DateTime? partiallyCompletedAt;

  const ServiceRequestStatusDateEntity({
    this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.onProgressAt,
    this.completedAt,
    this.unProcessableAt,
    this.closedAt,
    this.cancelledAt,
    this.partiallyCompletedAt,
  });

  String getCreatedAtString() {
    DateTime? date = createdAt;
    if (date == null) return '-';
    date = date.toLocal();
    return DateFormat(' d MMM yyyy', 'id_ID').format(date);
  }

  String getDateString(ServiceRequestStatus status) {
    DateTime? date;

    switch (status) {
      case ServiceRequestStatus.received:
        date = createdAt;
        break;

      case ServiceRequestStatus.approved:
        date = approvedAt;
        break;

      case ServiceRequestStatus.rejected:
        date = rejectedAt;
        break;

      case ServiceRequestStatus.onProgress:
        date = onProgressAt;
        break;

      case ServiceRequestStatus.completed:
        date = completedAt;
        break;

      case ServiceRequestStatus.unProcessable:
        date = unProcessableAt;
        break;

      case ServiceRequestStatus.closed:
        date = closedAt;
        break;

      case ServiceRequestStatus.cancelled:
        date = cancelledAt;
        break;

      case ServiceRequestStatus.partiallyCompleted:
        date = partiallyCompletedAt;
        break;
    }
    if (date == null) return '-';
    date = date.toLocal();
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
  }
}
