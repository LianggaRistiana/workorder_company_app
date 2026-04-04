import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/provider_service_request_entity.dart';

abstract class InternalServiceRequestRepository {
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequest();
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(String id);
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(String id);
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(String id);
}
