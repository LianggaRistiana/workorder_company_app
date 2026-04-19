import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/data/model/work_report_model.dart';

abstract class WorkReportRemoteDatasource {
  ApiFuture<WorkReportModel> getWorkReport(String workOrderId);
  ApiFuture<WorkReportModel> submitWorkReportSubmission(String workReportId);
  ApiFuture<WorkReportModel> sendWorkReport(String workReportId);
  ApiFuture<WorkReportModel> approveWorkReport(String workReportId);
  ApiFuture<WorkReportModel> rejectWorkReport(String workReportId);
}
