import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';

abstract class ClientServiceRequestRepository {
  Future<Either<Failure, List<ClientServiceRequestEntity>>>
      publicGetClientServiceRequests();
  Future<Either<Failure, ClientServiceRequestEntity>>
      publicGetClientServiceRequestById(String id);
  Future<Either<Failure, List<ClientServiceRequestEntity>>>
      getClientServiceRequests();
  Future<Either<Failure, ClientServiceRequestEntity>>
      getClientServiceRequestById(String id);
}
