import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/event_bus/notification_event_bus.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/listener/fcm_listener.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:workorder_company_app/features/notification/data/repositories/notification_cache_invalidator.dart';
import 'package:workorder_company_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/disable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/enable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_logs_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_status_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/init_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/dispatcher/notification_dispatcher.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/handler/notification_handler.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';
import 'package:workorder_company_app/routes/app_router.dart';

Future<void> initNotificationFeature() async {
  sl.registerLazySingleton<FcmDataSource>(
    () => FcmDataSourceImpl(FirebaseMessaging.instance),
  );

  sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl());

  sl.registerLazySingleton<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(
            sl<ApiClient>(),
          ));

  sl.registerLazySingleton<NotificationHandler>(
    () => NotificationHandler(
      sl<NotificationDispatcher>(),
      sl<NotificationEventBus>(),
    ),
  );

  sl.registerLazySingleton<NotificationDispatcher>(
    () => NotificationDispatcher(
      sl<NotificationNavigator>(),
    ),
  );

  sl.registerFactory<NotificationNavigator>(
    () => NotificationNavigatorImpl(appRouter, sl<AuthRepository>()),
  );

  sl.registerLazySingleton<FcmListener>(
    () => FcmListener(
      sl<FcmDataSource>(),
      sl<NotificationHandler>(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(
            sl<NotificationLocalDataSource>(),
            sl<NotificationRemoteDatasource>(),
            sl<FcmDataSource>(),
          ));

  sl.registerSingleton<NotificationEventBus>(
    NotificationEventBus(),
  );

  sl.registerSingleton(
    NotificationCacheInvalidator(
      sl<NotificationEventBus>(),
      sl<NotificationRepository>(),
    ),
  );

  sl.registerLazySingleton<EnableNotificationUseCase>(
      () => EnableNotificationUseCase(
            sl<NotificationRepository>(),
          ));

  sl.registerLazySingleton<DisableNotificationUseCase>(
      () => DisableNotificationUseCase(
            sl<NotificationRepository>(),
          ));

  sl.registerLazySingleton<GetNotificationStatusUseCase>(
      () => GetNotificationStatusUseCase(
            sl<NotificationRepository>(),
          ));

  sl.registerLazySingleton<InitNotificationUseCase>(
      () => InitNotificationUseCase(
            sl<NotificationRepository>(),
          ));

  sl.registerLazySingleton<GetNotificationLogsUseCase>(
      () => GetNotificationLogsUseCase(
            sl<NotificationRepository>(),
          ));

  sl.registerLazySingleton<MarkNotificationAsReadUsecase>(
      () => MarkNotificationAsReadUsecase(
            sl<NotificationRepository>(),
          ));

  sl.registerFactory<NotificationActiveCubit>(() => NotificationActiveCubit(
        sl<EnableNotificationUseCase>(),
        sl<DisableNotificationUseCase>(),
        sl<GetNotificationStatusUseCase>(),
      ));

  sl.registerFactory<NotificationLogCubit>(() => NotificationLogCubit(
        sl<GetNotificationLogsUseCase>(),
        sl<MarkNotificationAsReadUsecase>(),
        sl<NotificationEventBus>().stream,
      ));
}
