import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/internal_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/internal_service_request_repository.dart';

class InternalServiceRequestRepositoryImpl
    implements InternalServiceRequestRepository {
  @override
  FutureEither<InternalServiceRequestEntity> approveServiceRequest(String id) {
    // TODO: implement approveServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEitherList<InternalServiceRequestEntity> getServiceRequest() {
    // TODO: implement getServiceRequest
    throw UnimplementedError();
  }

  @override
  FutureEither<InternalServiceRequestEntity> getServiceRequestDetail(
      String id) {
    // TODO: implement getServiceRequestDetail
    throw UnimplementedError();
  }

  @override
  FutureEither<InternalServiceRequestEntity> rejectServiceRequest(String id) {
    // TODO: implement rejectServiceRequest
    throw UnimplementedError();
  }
}
