import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class RequesterServiceRequestRepository {
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequests();
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id);
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(String id);
  FutureEither<FormEntity> getIntakeForm(String serviceId);
  FutureEither<RequesterServiceRequestEntity> submitReviewForm(
      String serviceId, SubmissionEntity submission);
  FutureEither<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceRequestId, SubmissionEntity submission);
}
