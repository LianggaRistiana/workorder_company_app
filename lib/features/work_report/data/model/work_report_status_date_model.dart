import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_status_date_entity.dart';

class WorkReportStatusDateModel extends WorkReportStatusDateEntity {
  const WorkReportStatusDateModel({
    super.createdAt,
    super.sentAt,
    super.approvedAt,
    super.rejectedAt,
  });

  factory WorkReportStatusDateModel.fromJson(Map<String, dynamic> json) {
    return WorkReportStatusDateModel(
      createdAt: json.field('createdAt').optDate(),
      sentAt: json.field('submittedAt').optDate(),
      approvedAt: json.field('approvedAt').optDate(),
      rejectedAt: json.field('rejectedAt').optDate(),
    );
  }
}
