import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class SubmitWorkReportSubmissionUsecase {
  final WorkReportRepository _repository;

  SubmitWorkReportSubmissionUsecase(this._repository);

  FutureEither<WorkReportEntity> call(
    WorkReportEntity workReport,
    SubmissionDraft submission,
  ) {
    return UseCaseExecutor.run(
      map: () => submission.toEntity(),
      authorize: null,
      action: (submission) => _repository.submitWorkReportSubmission(
        workReport.id,
        submission,
      ),
    );
  }
}
