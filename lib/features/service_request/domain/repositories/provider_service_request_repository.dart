import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

abstract class ProviderServiceRequestRepository
    implements Cacheable, StreamableCache {
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequests();
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(String id);
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(String id);
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(String id);
}
