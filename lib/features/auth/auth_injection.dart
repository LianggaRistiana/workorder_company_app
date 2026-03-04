import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/features/auth/domain/policy/user_registration_policy.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/user_registration_usecase.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';

Future<void> initAuthFeature() async {
  /// Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(
      loginUseCase: sl(),
      getCurrentUserUsecase: sl(),
      logoutUsecase: sl(),
      userRegistrationUsecase: sl()));

  /// Policies
  sl.registerLazySingleton<UserRegistrationPolicy>(
      () => UserRegistrationPolicy());

  /// Usecases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl(), sl()));
  sl.registerLazySingleton<GetCurrentUserUsecase>(
      () => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl()));
  sl.registerLazySingleton<UserRegistrationUsecase>(
      () => UserRegistrationUsecase(sl(), sl()));

  /// Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl(), sl()));

  /// Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );
}
