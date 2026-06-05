import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';

class KickEmployeeUsecase {
  final EmployeesRepository _repository;

  KickEmployeeUsecase(this._repository);

  FutureEither<Empty> call(UserEntity user) {
    return _repository.kickEmployee(user);
  }
}
