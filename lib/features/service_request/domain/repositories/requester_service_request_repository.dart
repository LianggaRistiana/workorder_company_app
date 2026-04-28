import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class RequesterServiceRequestRepository
    implements Cacheable, StreamableCache {
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequests({
    bool forceRefresh = false,
  });
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id);
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(String id);
  FutureEither<FormEntity> getIntakeForm(String serviceId, UserRole role);
  FutureEither<FormEntity> getReviewForm(String serviceRequestId);
  FutureEither<RequesterServiceRequestEntity> submitReviewForm(
      String serviceRequestId, SubmissionEntity submission);
  FutureEither<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceId, SubmissionEntity submission);
}
