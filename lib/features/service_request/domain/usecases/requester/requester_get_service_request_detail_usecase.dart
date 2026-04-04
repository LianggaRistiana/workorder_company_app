import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetServiceRequestDetailUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterGetServiceRequestDetailUsecase(this.repository);

  FutureEither<RequesterServiceRequestEntity> call(String id) async {
    return repository.getServiceRequestDetail(id);
  }
}
