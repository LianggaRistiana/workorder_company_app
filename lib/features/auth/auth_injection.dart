import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';

Future<void> initAuthFeature() async {
  /// Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(loginUseCase: sl(), getCurrentUserUsecase: sl()));

  /// Usecases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<GetCurrentUserUsecase>(() => GetCurrentUserUsecase(sl()));

  /// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(),sl()));

  /// Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );
}
