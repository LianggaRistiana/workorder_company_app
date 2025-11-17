import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/client_service_request/data/datasources/client_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/domain/repositories/client_service_request_repository.dart';

class ClientServiceRequestRepositoryImpl
    implements ClientServiceRequestRepository {
  final ClientServiceRequestRemoteDatasource
      _clientServiceRequestRemoteDatasource;

  ClientServiceRequestRepositoryImpl(
      this._clientServiceRequestRemoteDatasource);

  @override
  Future<Either<Failure, ClientServiceRequestEntity>>
      publicGetClientServiceRequestById(String id) {
    // TODO: implement publicGetClientServiceRequestById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ClientServiceRequestEntity>>>
      publicGetClientServiceRequests() {
    return safeCall(() async {
      final payload = await _clientServiceRequestRemoteDatasource
          .publicGetClientServiceRequests();
      return payload.data ?? [];
    });
  }
}
