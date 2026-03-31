import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class RequesterServiceRequestRepository {
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequest();
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id);
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(String id);
  FutureEither<RequesterServiceRequestEntity> submitReview(
      SubmissionEntity submission);
}
