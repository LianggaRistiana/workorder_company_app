import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/repositories/client_service_request_repository.dart';

class RejectCsrUsecase {
  final ClientServiceRequestRepository _repository;

  RejectCsrUsecase(this._repository);

  Future<Either<Failure, void>> call(String id) async {
    return await _repository.rejectClientServiceRequest(id);
  }
}
