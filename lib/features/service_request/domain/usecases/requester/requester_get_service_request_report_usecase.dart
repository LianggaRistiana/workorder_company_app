import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/work_reports_filled_form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetServiceRequestReportUsecase {
  final RequesterServiceRequestRepository _repository;

  RequesterGetServiceRequestReportUsecase(this._repository);

  FutureEither<WorkReportsFilledFormEntity> call(String id) {
    return _repository.getServiceRequestReport(id);
  }
}
