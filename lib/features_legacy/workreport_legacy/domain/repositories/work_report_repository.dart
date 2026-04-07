import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/entitties/work_report_entity.dart';

abstract class WorkReportRepository {
  Future<Either<Failure, WorkReportEntity>> getWorkReportByWorkorderId(
      String id);
  Future<Either<Failure, void>> submitWorkReportByWorkorderId(
      String id, List<SubmissionEntity> submissions);
}
