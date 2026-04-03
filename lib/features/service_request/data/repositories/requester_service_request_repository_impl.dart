import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class RequesterServiceRequestRepositoryImpl
    implements RequesterServiceRequestRepository {
  RequesterServiceRequestDatasource _requesterServiceRequestDatasource;

  RequesterServiceRequestRepositoryImpl(
      this._requesterServiceRequestDatasource);

  @override
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(String id) {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.cancelServiceRequest(id);
      return payload.data!;
    });
  }

  @override
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequests() {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.getServiceRequests();
      return payload.data ?? [];
    });
  }

  @override
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id) {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.getServiceRequestDetail(id);
      return payload.data!;
    });
  }

  @override
  FutureEither<FormEntity> getIntakeForm(String serviceId) {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.getIntakeForm(serviceId);
      return payload.data!;
    });
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceId, SubmissionEntity submission) {
    return safeCall(() async {
      final payload = await _requesterServiceRequestDatasource.submitIntakeForm(
          serviceId, SubmissionsModel.fromEntity(submission));
      return payload.data!;
    });
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitReviewForm(
      String serviceRequestId, SubmissionEntity submission) {
    return safeCall(() async {
      final payload = await _requesterServiceRequestDatasource.submitIntakeForm(
          serviceRequestId, SubmissionsModel.fromEntity(submission));
      return payload.data!;
    });
  }

  @override
  FutureEither<FormEntity> getReviewForm(String serviceRequestId) {
    return safeCall(() async {
      final payload = await _requesterServiceRequestDatasource
          .getReviewForm(serviceRequestId);
      return payload.data!;
    });
  }
}
