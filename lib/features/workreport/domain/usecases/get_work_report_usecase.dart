import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/workreport/domain/entitties/work_report_entity.dart';
import 'package:workorder_company_app/features/workreport/domain/repositories/work_report_repository.dart';

class GetWorkReportUsecase {
  final WorkReportRepository _workReportRepository;

  GetWorkReportUsecase(this._workReportRepository);

  Future<Either<Failure, WorkReportEntity>> call(String id) async {
    return await _workReportRepository.getWorkReportByWorkorderId(id);
  }
}
