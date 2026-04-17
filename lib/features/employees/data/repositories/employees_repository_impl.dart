import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';
import 'package:workorder_company_app/core/cache/list_cache_helper.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDatasource _remoteDatasource;

  final ListCacheHelper<UserEntity> _cache = ListCacheHelper();

  EmployeesRepositoryImpl(this._remoteDatasource);

  @override
  FutureEitherList<UserEntity> getEmployees({
    EmployeesParams? params,
    bool forceRefresh = false,
  }) async {
    final result = await _cache.fetchList(
      remoteCall: () async {
        final response = await _remoteDatasource.getEmployees();
        return response.data;
      },
      forceRefresh: forceRefresh,
    );

    return result.map((employees) {
      if (params == null) return employees;

      return _applyFilter(employees, params);
    });
  }

  List<UserEntity> _applyFilter(
    List<UserEntity> employees,
    EmployeesParams params,
  ) {
    return employees.where((e) {
      final matchSearch = params.search == null ||
          e.name.toLowerCase().contains(params.search!.toLowerCase());

      final matchPosition =
          params.positionId == null || e.position?.id == params.positionId;

      return matchSearch && matchPosition;
    }).toList();
  }
}
