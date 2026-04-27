import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';

abstract class EmployeesRepository implements Cacheable {
  FutureEitherList<UserEntity> getEmployees({
    EmployeesParams? params,
    bool forceRefresh = false,
  });
}
// TODO : Make this repo streamablecache if there is feature kick out employee
