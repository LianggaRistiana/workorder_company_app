import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';

class WorkReportEntity {
  final String id;
  final String workOrderId;
  final String companyId;
  // final ReportStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<FilledFormWithHistoryEntity>? reportForms;

  WorkReportEntity({
    required this.id,
    required this.workOrderId,
    required this.companyId,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.reportForms,
  });
}
