import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/fcm/fcm_listener.dart';
import 'package:workorder_company_app/core/services/navigation/app_navigator_key.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/presentation/dispatcher/notification_dispatcher.dart';
import 'package:workorder_company_app/features/notification/presentation/handler/notification_handler.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';
// import 'package:workorder_company_app/features/notification/presentation/bloc/notification_cubit.dart';

Future<void> initNotificationFeature() async {
  sl.registerLazySingleton<FcmDataSource>(
    () => FcmDataSourceImpl(FirebaseMessaging.instance),
  );

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
