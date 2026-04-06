import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderGetServiceRequestDetailUsecase {
  final InternalServiceRequestRepository repository;

  ProviderGetServiceRequestDetailUsecase(this.repository);

  FutureEither<ProviderServiceRequestEntity> call(String id) async {
    // TODO : add authorization rule here
    return repository.getServiceRequestDetail(id);
  }
}
