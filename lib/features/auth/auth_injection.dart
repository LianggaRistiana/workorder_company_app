import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/company_registration_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/user_registration_usecase.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';

Future<void> initAuthFeature() async {
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      getCurrentUserUsecase: sl(),
      logoutUsecase: sl(),
      userRegistrationUsecase: sl(),
      companyRegistrationUsecase: sl(),
      initNotificationUseCase: sl(),
    ),
  );

  /// Usecases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl(), sl()));
  sl.registerLazySingleton<GetCurrentUserUsecase>(
      () => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl(), sl()));
  sl.registerLazySingleton<CompanyRegistrationUsecase>(
      () => CompanyRegistrationUsecase(sl()));
  sl.registerLazySingleton<UserRegistrationUsecase>(
      () => UserRegistrationUsecase(sl()));

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
