import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/work_report/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class WorkReportRepositoryImpl implements WorkReportRepository {
  final WorkReportRemoteDatasource _remoteDatasource;

  WorkReportRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<WorkReportEntity> approveWorkReport(String workReportId) {
    return safeCall(() async {
      final payload = await _remoteDatasource.approveWorkReport(workReportId);
      return payload.data;
    });
  }

  @override
  FutureEither<WorkReportEntity> getWorkReport(String workOrderId) {
    return safeCall(() async {
      final payload = await _remoteDatasource.getWorkReport(workOrderId);
      return payload.data;
    });
  }

  @override
  FutureEither<WorkReportEntity> rejectWorkReport(String workReportId) {
    return safeCall(() async {
      final payload = await _remoteDatasource.rejectWorkReport(workReportId);
      return payload.data;
    });
  }

  @override
  FutureEither<WorkReportEntity> sendWorkReport(String workReportId) {
    return safeCall(() async {
      final payload = await _remoteDatasource.sendWorkReport(workReportId);
      return payload.data;
    });
  }

  @override
  FutureEither<WorkReportEntity> submitWorkReportSubmission(
      String workReportId, SubmissionEntity submission) {
    return safeCall(() async {
      final payload = await _remoteDatasource.submitWorkReportSubmission(
          workReportId, SubmissionsModel.fromEntity(submission));
      return payload.data;
    });
  }
}
