import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetReviewFormUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterGetReviewFormUsecase(this.repository);

  FutureEither<FormEntity> call(String serviceRequestId) async {
    return repository.getReviewForm(serviceRequestId);
  }
}
