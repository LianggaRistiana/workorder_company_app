import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
// import 'package:workorder_company_app/features/notification/presentation/bloc/notification_cubit.dart';

Future<void> initNotificationFeature() async {
  sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl());

  // sl.registerLazySingleton<NotificationRepository>(
  //     () => NotificationRepositoryImpl(sl()));

  // sl.registerLazySingleton<EnableNotificationUsecase>(
  //     () => EnableNotificationUsecase(sl()));

  // sl.registerLazySingleton<DisableNotificationUsecase>(
  //     () => DisableNotificationUsecase(sl()));

  // sl.registerFactory<NotificationCubit>(() => NotificationCubit(
  //     enableUsecase: sl(), disableUsecase: sl(), repository: sl()));
}
