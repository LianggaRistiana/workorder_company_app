import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/workreport/domain/repositories/work_report_repository.dart';

class SubmitWorkReportUsecase {
  final WorkReportRepository _workReportRepository;

  SubmitWorkReportUsecase(this._workReportRepository);

  Future<Either<Failure, void>> call(
      String id, List<SubmissionEntity> submissions) async {
    return await _workReportRepository.submitWorkReportByWorkorderId(
        id, submissions);
  }
}
