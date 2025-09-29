import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initAuthFeature() async {
  /// Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(loginUseCase: sl()));

  /// Usecases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  /// Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  /// Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
}
