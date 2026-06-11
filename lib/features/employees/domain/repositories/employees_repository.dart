import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';

abstract class EmployeesRepository implements Cacheable, StreamableCache {
  FutureEitherList<UserEntity> getEmployees({
    EmployeesParams? params,
    bool forceRefresh = false,
  });
  FutureEitherWithMeta<Empty> getEmployeeByDetail(String id);
  FutureEither<Empty> kickEmployee(UserEntity user);
}
