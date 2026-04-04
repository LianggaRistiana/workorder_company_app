import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetServiceRequestsUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterGetServiceRequestsUsecase(this.repository);

  FutureEitherList<RequesterServiceRequestEntity> call() async {
    return repository.getServiceRequests();
  }
}
