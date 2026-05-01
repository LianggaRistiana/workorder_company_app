import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/core/upload_helper.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';

class RequesterSubmitReviewFormUsecase {
  final RequesterServiceRequestRepository _repository;
  final UploadManager _uploadManager;
  late final UploadHelper _uploadHelper;

  RequesterSubmitReviewFormUsecase(
    this._repository,
    this._uploadManager,
  ) {
    _uploadHelper = UploadHelper(_uploadManager);
  }

  FutureEither<RequesterServiceRequestEntity> call(
      String serviceRequestId, SubmissionDraft submission) async {
    return UseCaseExecutor.runWithFutureMap(
      map: () async {
        final processedDraft = await _uploadHelper.processDraft(submission);
        return processedDraft.toEntity();
      },
      authorize: null,
      action: (entity) =>
          _repository.submitReviewForm(serviceRequestId, entity),
    );
  }
}
