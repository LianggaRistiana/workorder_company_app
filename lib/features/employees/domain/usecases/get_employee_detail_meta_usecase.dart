import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';

// NOTE: This use case only retrieves metadata for a single staff member, hence the naming below.
class GetEmployeeDetailMetaUsecase {
  final EmployeesRepository _repository;

  GetEmployeeDetailMetaUsecase(this._repository);

  FutureEitherWithMeta<Empty> call(String email) {
    return _repository.getEmployeeByEmail(email);
  }
}
