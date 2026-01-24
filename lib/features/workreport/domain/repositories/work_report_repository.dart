import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/workreport/domain/entitties/work_report_entity.dart';

abstract class WorkReportRepository {
  Future<Either<Failure, WorkReportEntity>> getWorkReportByWorkorderId(
      String id);
  Future<Either<Failure, WorkReportEntity>> submitWorkReportByWorkorderId(
      String id);
}
