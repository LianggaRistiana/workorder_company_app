import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/provider_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderServiceRequestRepositoryImpl
    implements InternalServiceRequestRepository {
  @override
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(String id) {
    // TODO: implement approveServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequest() {
    // TODO: implement getServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(
      String id) {
    // TODO: implement getServiceRequestDetail
    throw UnimplementedError();
  }

  @override
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(String id) {
    // TODO: implement rejectServiceRequest
    throw UnimplementedError();
  }
}
