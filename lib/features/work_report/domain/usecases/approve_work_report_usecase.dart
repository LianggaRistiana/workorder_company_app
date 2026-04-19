import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class ApproveWorkReportUsecase {
  final WorkReportRepository _repository;

  ApproveWorkReportUsecase(this._repository);

  FutureEither<WorkReportEntity> call(WorkReportEntity workReport) {
    return UseCaseExecutor.runDirect(
      entity: workReport,
      authorize: null,
      action: (entity) => _repository.approveWorkReport(entity.id),
    );
  }
}
