import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDatasource _remoteDatasource;

  EmployeesRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<UserEntity>>> getEmployees() {
    return safeCall(() async {
      final response = await _remoteDatasource.getEmployees();
      final employees =
          response.data?.map((e) => e as UserEntity).toList() ?? [];
      return employees;
    });
  }
}
