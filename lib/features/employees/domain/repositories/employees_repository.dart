import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';

abstract class EmployeesRepository {
  FutureEitherList<UserEntity> getEmployees({
    EmployeesParams? params,
    bool forceRefresh = false,
  });
}
