import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/core/upload_helper.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class SubmitWorkReportSubmissionUsecase {
  final WorkReportRepository _repository;
  final UploadManager _uploadManager;
  late final UploadHelper _uploadHelper;

  SubmitWorkReportSubmissionUsecase(this._repository, this._uploadManager) {
    _uploadHelper = UploadHelper(_uploadManager);
  }

  FutureEither<WorkReportEntity> call(
    WorkReportEntity workReport,
    SubmissionDraft submission,
  ) {
    return UseCaseExecutor.runWithFutureMap(
      map: () async {
        final processedDraft = await _uploadHelper.processDraft(submission);
        return processedDraft.toEntity();
      },
      authorize: null,
      action: (submission) => _repository.submitWorkReportSubmission(
        workReport.id,
        submission,
      ),
    );
  }
}
