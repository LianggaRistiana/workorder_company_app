import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class RequesterServiceRequestDatasource {
  ApiFutureList<RequesterServiceRequestEntity> getServiceRequest();
  ApiFuture<RequesterServiceRequestEntity> getServiceRequestDetail(String id);
  ApiFuture<RequesterServiceRequestEntity> cancelServiceRequest(String id);
  ApiFuture<FormEntity> getIntakeForm(String serviceId);
  ApiFuture<RequesterServiceRequestEntity> submitReviewForm(
      String serviceRequestId, SubmissionEntity submission);
  ApiFuture<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceId, SubmissionEntity submission);
}

class RequesterServiceRequestDatasourceImpl
    implements RequesterServiceRequestDatasource {
  @override
  ApiFuture<RequesterServiceRequestEntity> cancelServiceRequest(String id) {
    // TODO: implement cancelServiceRequest
    throw UnimplementedError();
  }

  @override
  ApiFuture<FormEntity> getIntakeForm(String serviceId) {
    // TODO: implement getIntakeForm
    throw UnimplementedError();
  }

  @override
  ApiFutureList<RequesterServiceRequestEntity> getServiceRequest() {
    // TODO: implement getServiceRequest
    throw UnimplementedError();
  }

  @override
  ApiFuture<RequesterServiceRequestEntity> getServiceRequestDetail(String id) {
    // TODO: implement getServiceRequestDetail
    throw UnimplementedError();
  }

  @override
  ApiFuture<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceId, SubmissionEntity submission) {
    // TODO: implement submitIntakeForm
    throw UnimplementedError();
  }

  @override
  ApiFuture<RequesterServiceRequestEntity> submitReviewForm(
      String serviceRequestId, SubmissionEntity submission) {
    // TODO: implement submitReviewForm
    throw UnimplementedError();
  }
}
