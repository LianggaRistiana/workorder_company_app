import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/disable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/enable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_cubit.dart';

Future<void> initNotificationFeature() async {
  sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl());

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl()));

  sl.registerLazySingleton<EnableNotificationUsecase>(
      () => EnableNotificationUsecase(sl()));

  sl.registerLazySingleton<DisableNotificationUsecase>(
      () => DisableNotificationUsecase(sl()));

  sl.registerFactory<NotificationCubit>(() => NotificationCubit(
      enableUsecase: sl(), disableUsecase: sl(), repository: sl()));

}
