import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class RequesterServiceRequestRepositoryImpl
    implements RequesterServiceRequestRepository {
  @override
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(String id) {
    // TODO: implement cancelServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequest() {
    // TODO: implement getServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id) {
    // TODO: implement getServiceRequestDetail
    throw UnimplementedError();
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitReviewForm(
      SubmissionEntity submission) {
    // TODO: implement submitReview
    throw UnimplementedError();
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitIntakeForm(
      SubmissionEntity submission) {
    // TODO: implement submitServiceRequestForm
    throw UnimplementedError();
  }

  @override
  FutureEither<FormEntity> getIntakeForm(String serviceId) {
    // TODO: implement getIntakeForm
    throw UnimplementedError();
  }
}
