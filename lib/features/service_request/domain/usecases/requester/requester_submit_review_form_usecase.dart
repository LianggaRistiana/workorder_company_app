import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';

class RequesterSubmitReviewFormUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterSubmitReviewFormUsecase(this.repository);

  FutureEither<RequesterServiceRequestEntity> call(
      String serviceRequestId, SubmissionDraft submission) async {
    return UseCaseExecutor.run(
      map: () => submission.toEntity(),
      action: (entity) =>
          repository.submitReviewForm(serviceRequestId, entity!),
    );
  }
}
