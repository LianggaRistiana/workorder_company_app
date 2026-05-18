import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/datasources/public_services_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/repositories/services_repository_impl.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_create_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_service_byid_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_get_services_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_remove_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_toggle_active_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/internal_update_service_usecase.dart';
import 'package:workorder_company_app/features/services/domain/usecases/public_get_services_usecase.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/action/service_action_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/detail/service_detail_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/update/service_update_cubit.dart';

Future<void> initServicesFeature() async {
  sl.registerLazySingleton<InternalServicesManagementRemoteDatasource>(
      // () => MockServiceRemoteDatasource());
  () => InternalServicesManagementRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<PublicServicesRemoteDatasource>(
      () => PublicServicesRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<ServicesRepository>(
      () => ServicesRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<InternalGetServicesUsecase>(
      () => InternalGetServicesUsecase(sl()));

  sl.registerLazySingleton<InternalCreateServiceUsecase>(
      () => InternalCreateServiceUsecase(sl()));

  sl.registerLazySingleton<InternalUpdateServiceUsecase>(
      () => InternalUpdateServiceUsecase(sl()));

  sl.registerLazySingleton<InternalGetServiceByidUsecase>(
      () => InternalGetServiceByidUsecase(sl()));

  sl.registerLazySingleton<InternalRemoveServiceUsecase>(
      () => InternalRemoveServiceUsecase(sl()));

  sl.registerLazySingleton<InternalToggleActiveServiceUsecase>(
      () => InternalToggleActiveServiceUsecase(sl()));

  sl.registerLazySingleton<PublicGetServicesUsecase>(
      () => PublicGetServicesUsecase(sl()));

  sl.registerFactory<ServicesListBloc>(
    () => ServicesListBloc(
      internalGetServicesUsecase: sl<InternalGetServicesUsecase>(),
      serviceChangedStream: sl<ServicesRepository>().cacheChanged,
    ),
  );

  sl.registerFactory<ServiceCreateCubit>(
    () => ServiceCreateCubit(sl()),
  );

  sl.registerFactory<ServiceUpdateCubit>(
    () => ServiceUpdateCubit(sl()),
  );

  sl.registerFactory<ServiceActionCubit>(
    () => ServiceActionCubit(sl(), sl()),
  );

  sl.registerFactory<ServiceDetailCubit>(
    () => ServiceDetailCubit(internalGetServiceByIdUsecase: sl()),
  );
}
