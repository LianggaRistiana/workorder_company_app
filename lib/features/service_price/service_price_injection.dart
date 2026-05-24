import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_price/data/datasources/service_price_remote_datasource.dart';
import 'package:workorder_company_app/features/service_price/data/repositories/service_price_repository_impl.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/add_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/delete_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/get_service_prices_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/update_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/presentation/bloc/service_price_cubit.dart';

Future<void> initServicePricesFeature() async {
  sl.registerLazySingleton<ServicePriceRemoteDatasource>(
    () => ServicePriceRemoteDatasourceImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton<ServicePriceRepository>(
    () => ServicePriceRepositoryImpl(
      sl(),
    ),
  );

  sl.registerLazySingleton<GetServicePricesUsecase>(
    () => GetServicePricesUsecase(
      sl(),
    ),
  );

  sl.registerLazySingleton<AddServicePriceUsecase>(
      () => AddServicePriceUsecase(sl()));

  sl.registerLazySingleton<UpdateServicePriceUsecase>(
      () => UpdateServicePriceUsecase(sl()));

  sl.registerLazySingleton<DeleteServicePriceUsecase>(
      () => DeleteServicePriceUsecase(sl()));

  sl.registerFactory<ServicePriceCubit>(
    () => ServicePriceCubit(
      getServicePricesUsecase: sl<GetServicePricesUsecase>(),
      addServicePriceUsecase: sl<AddServicePriceUsecase>(),
      updateServicePriceUsecase: sl<UpdateServicePriceUsecase>(),
      deleteServicePriceUsecase: sl<DeleteServicePriceUsecase>(),
    ),
  );
}
