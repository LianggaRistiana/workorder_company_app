import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/repositories/client_service_request_repository.dart';

class ApproveCsrUsecase {
  final ClientServiceRequestRepository _clientServiceRequestRepository;

  ApproveCsrUsecase(this._clientServiceRequestRepository);

  Future<Either<Failure, String>> call(String id) async {
    return _clientServiceRequestRepository.approveClientServiceRequest(id);
  }
}
