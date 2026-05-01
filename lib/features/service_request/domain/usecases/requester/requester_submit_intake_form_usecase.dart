import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/core/upload_helper.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';

// class RequesterSubmitIntakeFormUsecase {
//   final RequesterServiceRequestRepository repository;
//   final UploadManager uploadManager;

//   RequesterSubmitIntakeFormUsecase(this.repository, this.uploadManager);

//   FutureEither<RequesterServiceRequestEntity> call(
//       String serviceId, SubmissionDraft submission) async {
//     return UseCaseExecutor.run(
//       map: () => submission.toEntity(),
//       authorize: null,
//       action: (entity) => repository.submitIntakeForm(serviceId, entity),
//     );
//   }
// }

class RequesterSubmitIntakeFormUsecase {
  final RequesterServiceRequestRepository repository;
  final UploadManager uploadManager;
  late final UploadHelper uploadHelper;

  RequesterSubmitIntakeFormUsecase(
    this.repository,
    this.uploadManager,
  ) {
    uploadHelper = UploadHelper(uploadManager);
  }

  FutureEither<RequesterServiceRequestEntity> call(
    String serviceId,
    SubmissionDraft submission,
  ) async {
    return UseCaseExecutor.run(
      map: () => submission,
      authorize: null,
      action: (draft) async {
        final processedDraft = await uploadHelper.processDraft(draft);

        return repository.submitIntakeForm(
          serviceId,
          processedDraft.toEntity(),
        );
      },
    );
  }
}
