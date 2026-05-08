import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_report_enum.dart';

class WorkReportStatusDateEntity extends Equatable {
  final DateTime? createdAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? sentAt;

  const WorkReportStatusDateEntity({
    this.createdAt,
    this.approvedAt,
    this.rejectedAt,
    this.sentAt,
  });

  String getDateString(WorkReportStatus status) {
    DateTime? date;

    switch (status) {
      case WorkReportStatus.onProgress:
        date = createdAt;
        break;
      case WorkReportStatus.approved:
        date = approvedAt;
        break;
      case WorkReportStatus.rejected:
        date = rejectedAt;

        break;
      case WorkReportStatus.sent:
        date = sentAt;
        break;
    }

    if (date == null) return '-';
    date = date.toLocal();
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  @override
  List<Object?> get props => [];
}
