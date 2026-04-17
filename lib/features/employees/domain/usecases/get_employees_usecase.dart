import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';

class GetEmployeesUsecase {
  final EmployeesRepository repository;

  GetEmployeesUsecase({required this.repository});

  Future<Either<Failure, List<UserEntity>>> call({
    EmployeesParams? params,
    bool forceRefresh = false,
  }) {
    return repository.getEmployees(
      params: params,
      forceRefresh: forceRefresh,
    );
  }
}
