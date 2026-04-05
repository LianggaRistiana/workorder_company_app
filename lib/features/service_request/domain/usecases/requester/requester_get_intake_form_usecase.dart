import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetIntakeFormUsecase {
  final RequesterServiceRequestRepository repository;

  RequesterGetIntakeFormUsecase(this.repository);

  // TODO : add switcher by user type
  FutureEither<FormEntity> call(String serviceId) async {
    return repository.getIntakeForm(serviceId);
  }
}
