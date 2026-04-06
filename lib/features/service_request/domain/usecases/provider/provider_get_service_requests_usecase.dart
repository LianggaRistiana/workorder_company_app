import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderGetServiceRequestsUsecase {
  final InternalServiceRequestRepository repository;

  ProviderGetServiceRequestsUsecase(this.repository);

  FutureEitherList<ProviderServiceRequestEntity> call() async {
    // TODO : add authorization rule here
    return repository.getServiceRequests();
  }
}
