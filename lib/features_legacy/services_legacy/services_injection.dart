import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/data/datasources/service_remote_datasource.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/data/repositories/service_repository_impl.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/repositories/service_repository.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/usecases/create_service_usecase.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/usecases/get_service_by_id_usecase.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/usecases/get_services_usecase.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/bloc/services_bloc.dart';

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
