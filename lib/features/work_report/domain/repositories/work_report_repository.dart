import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

abstract class WorkReportRepository {
  FutureEither<WorkReportEntity> getWorkReport(String workOrderId);
  FutureEither<WorkReportEntity> submitWorkReportSubmission(
    String workReportId,
    SubmissionEntity submission,
  );
  FutureEither<WorkReportEntity> sendWorkReport(String workReportId);
  FutureEither<WorkReportEntity> approveWorkReport(String workReportId);
  FutureEither<WorkReportEntity> rejectWorkReport(String workReportId);
}
