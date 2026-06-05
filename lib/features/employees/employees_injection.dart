import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';
import 'package:workorder_company_app/features/employees/data/repositories/employees_repository_impl.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/get_employee_detail_meta_usecase.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/get_employees_usecase.dart';
import 'package:workorder_company_app/features/employees/domain/usecases/kick_employee_usecase.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employee_detail_action_cubit.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';

Future<void> initEmployeesFeature() async {
  // datasource
  sl.registerLazySingleton<EmployeesRemoteDatasource>(
    () => EmployeesRemoteDatasourceImpl(sl()),
  );

  // repository
  sl.registerLazySingleton<EmployeesRepository>(
      () => EmployeesRepositoryImpl(sl()));

  // usecase
  sl.registerLazySingleton<GetEmployeesUsecase>(
    () => GetEmployeesUsecase(repository: sl()),
  );
  sl.registerLazySingleton<GetEmployeeDetailMetaUsecase>(
    () => GetEmployeeDetailMetaUsecase(sl()),
  );
  sl.registerLazySingleton<KickEmployeeUsecase>(
    () => KickEmployeeUsecase(sl()),
  );

  // bloc
  sl.registerFactory<EmployeesBloc>(
    () => EmployeesBloc(
      getEmployeesUsecase: sl(),
      cacheChangedStream: sl<EmployeesRepository>().cacheChanged,
    ),
  );

  sl.registerFactory<EmployeeDetailActionCubit>(
    () => EmployeeDetailActionCubit(
      kickEmployeeUsecase: sl(),
      getEmployeeDetailMetaUsecase: sl(),
    ),
  );
}
