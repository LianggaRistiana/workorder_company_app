import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class RejectWorkReportUsecase {
  final WorkReportRepository _repository;

  RejectWorkReportUsecase(this._repository);

  FutureEither<WorkReportEntity> call(WorkReportEntity workReport) {
    return UseCaseExecutor.runDirect(
      entity: workReport,
      authorize: null,
      action: (entity) => _repository.rejectWorkReport(entity.id),
    );
  }
}
