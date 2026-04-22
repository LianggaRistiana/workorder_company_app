import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderRejectServiceRequestUsecase {
  final ProviderServiceRequestRepository repository;

  ProviderRejectServiceRequestUsecase(this.repository);

  FutureEither<ProviderServiceRequestEntity> call(ProviderServiceRequestEntity entity) async {
    // OPTIMZE[Medium] : add authorization rule here
    return repository.rejectServiceRequest(entity.id);
  }
}
