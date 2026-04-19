import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class SendWorkReportUsecase {
  final WorkReportRepository _repository;

  SendWorkReportUsecase(this._repository);

  FutureEither<WorkReportEntity> call(WorkReportEntity workReport) {
    return UseCaseExecutor.runDirect(
      entity: workReport,
      authorize: null,
      action: (entity) => _repository.sendWorkReport(entity.id),
    );
  }
}
