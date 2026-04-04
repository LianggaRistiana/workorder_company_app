import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class RequesterSubmitReviewFormUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterSubmitReviewFormUsecase(this.repository);

  FutureEither<RequesterServiceRequestEntity> call(
      String serviceRequestId, SubmissionEntity submission) async {
    return repository.submitReviewForm(serviceRequestId, submission);
  }
}
