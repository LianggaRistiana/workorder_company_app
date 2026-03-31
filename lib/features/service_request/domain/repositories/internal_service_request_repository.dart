import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/internal_service_request_entity.dart';

abstract class InternalServiceRequestRepository {
  FutureEitherList<InternalServiceRequestEntity> getServiceRequest();
  FutureEither<InternalServiceRequestEntity> getServiceRequestDetail(String id);
  FutureEither<InternalServiceRequestEntity> approveServiceRequest(String id);
  FutureEither<InternalServiceRequestEntity> rejectServiceRequest(String id);
}
