import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_create_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_service_byid_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_services_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/detail/service_detail_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_bloc.dart';

Future<void> initServicesFeature() async {
  sl.registerLazySingleton<InternalServicesManagementRemoteDatasource>(
      () => InternalServicesManagementRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<ServicesRepository>(
      () => ServicesRepositoryImpl(sl()));

  sl.registerLazySingleton<InternalGetServicesUsecase>(
      () => InternalGetServicesUsecase(sl()));

  sl.registerLazySingleton<InternalCreateServiceUsecase>(
      () => InternalCreateServiceUsecase(sl()));

  sl.registerLazySingleton<InternalGetServiceByidUsecase>(
      () => InternalGetServiceByidUsecase(sl()));

  sl.registerFactory<ServicesListBloc>(
    () => ServicesListBloc(internalGetServicesUsecase: sl()),
  );

  sl.registerFactory<ServiceCreateCubit>(
    () => ServiceCreateCubit(sl()),
  );

  sl.registerFactory<ServiceDetailCubit>(
    () => ServiceDetailCubit(internalGetServiceByIdUsecase: sl()),
  );
}
