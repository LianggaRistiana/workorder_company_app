import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/repositories/client_service_request_repository.dart';

class GetCsrDetailUsecase {
  final ClientServiceRequestRepository _clientServiceRequestRepository;

  GetCsrDetailUsecase(this._clientServiceRequestRepository);

  Future<Either<Failure, ClientServiceRequestEntity>> call(String id) async {
    return _clientServiceRequestRepository.getClientServiceRequestById(id);
  }
}
