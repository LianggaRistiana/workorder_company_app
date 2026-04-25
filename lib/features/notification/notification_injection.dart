import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/fcm/fcm_listener.dart';
import 'package:workorder_company_app/core/services/navigation/app_navigator_key.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:workorder_company_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/disable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/enable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_status_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/init_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/dispatcher/notification_dispatcher.dart';
import 'package:workorder_company_app/features/notification/presentation/handler/notification_handler.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';

Future<void> initNotificationFeature() async {
  sl.registerLazySingleton<FcmDataSource>(
    () => FcmDataSourceImpl(FirebaseMessaging.instance),
  );

  sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl());

  sl.registerLazySingleton<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<NotificationHandler>(
    () => NotificationHandler(sl()), // OPTIMIZE THIS MUST BE IN DOMAIN LAYER
  );

  sl.registerLazySingleton<NotificationDispatcher>(
    () => NotificationDispatcher(sl()),
  );

  sl.registerLazySingleton<NotificationNavigator>(
    () => NotificationNavigatorImpl(navigatorKey),
  );

  sl.registerLazySingleton<FcmListener>(
    () => FcmListener(
      sl<FcmDataSource>(),
      sl<NotificationHandler>(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(sl(), sl(), sl()));

  sl.registerLazySingleton<EnableNotificationUseCase>(
      () => EnableNotificationUseCase(sl()));

  sl.registerLazySingleton<DisableNotificationUseCase>(
      () => DisableNotificationUseCase(sl()));

  sl.registerLazySingleton<GetNotificationStatusUseCase>(
      () => GetNotificationStatusUseCase(sl()));

  sl.registerLazySingleton<InitNotificationUseCase>(
      () => InitNotificationUseCase(sl()));

  sl.registerFactory<NotificationActiveCubit>(
      () => NotificationActiveCubit(sl(), sl(), sl()));
}
