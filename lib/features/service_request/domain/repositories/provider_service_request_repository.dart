import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

abstract class ProviderServiceRequestRepository {
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequests();
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(String id);
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(String id);
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(String id);
}
