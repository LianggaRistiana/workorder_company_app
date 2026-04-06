import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';

class RequesterGetIntakeFormUsecase {
  final RequesterServiceRequestRepository repository;
  final AuthRepository authRepository;

  RequesterGetIntakeFormUsecase(this.repository, this.authRepository);

  FutureEither<FormEntity> call(String serviceId) async {
    final role = authRepository.currentUser?.role;
    if (role == null) {
      return Left(AuthFailure(message: "User Data Invalid"));
    }

    return repository.getIntakeForm(serviceId, role);
  }
}
