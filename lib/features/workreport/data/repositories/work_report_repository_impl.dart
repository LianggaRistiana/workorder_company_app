import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/workreport/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features/workreport/domain/entitties/work_report_entity.dart';
import 'package:workorder_company_app/features/workreport/domain/repositories/work_report_repository.dart';

class WorkReportRepositoryImpl implements WorkReportRepository {
  final WorkReportRemoteDatasource _workReportRemoteDatasource;

  WorkReportRepositoryImpl(this._workReportRemoteDatasource);

  @override
  Future<Either<Failure, WorkReportEntity>> getWorkReportByWorkorderId(
      String id) async {
    return safeCall(() async {
      final payload =
          await _workReportRemoteDatasource.getWorkReportByWorkorderId(id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, WorkReportEntity>> submitWorkReportByWorkorderId(
      String id) {
    // TODO: implement submitWorkReportByWorkorderId
    throw UnimplementedError();
  }
}
