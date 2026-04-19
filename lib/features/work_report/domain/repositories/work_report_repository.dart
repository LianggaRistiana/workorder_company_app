import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/entitties/work_report_entity.dart';

abstract class WorkReportRepository {
  FutureEither<WorkReportEntity> getWorkReport(String workOrderId);
  FutureEither<WorkReportEntity> submitWorkReportSubmission(
      String workReportId);
  FutureEither<WorkReportEntity> sendWorkReport(String workReportId);
  FutureEither<WorkReportEntity> approveWorkReport(String workReportId);
  FutureEither<WorkReportEntity> rejectWorkReport(String workReportId);
}
