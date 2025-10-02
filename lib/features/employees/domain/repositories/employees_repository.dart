import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, List<UserEntity>>> getEmployees();
}
