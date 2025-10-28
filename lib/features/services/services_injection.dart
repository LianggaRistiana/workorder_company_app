import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/repositories/service_repository_impl.dart';
import 'package:workorder_company_app/features/services/domain/repositories/service_repository.dart';
import 'package:workorder_company_app/features/services/domain/usecases/create_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/get_service_by_id_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/get_services_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';

Future<void> initServicesFeature() async {
  sl.registerLazySingleton<ServiceRemoteDatasource>(
      () => ServiceRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(sl()));

  sl.registerLazySingleton<GetServicesUsecase>(() => GetServicesUsecase(sl()));
  sl.registerLazySingleton<GetServiceByIdUsecase>(
      () => GetServiceByIdUsecase(sl()));
  sl.registerLazySingleton<CreateServiceUsecase>(
      () => CreateServiceUsecase(sl()));

  sl.registerFactory<ServicesBloc>(() => ServicesBloc(
      getServicesUsecase: sl(),
      getServiceByIdUsecase: sl(),
      createServiceUsecase: sl()));

  sl.registerFactory<AddServiceCubit>(() => AddServiceCubit(sl()));
}
