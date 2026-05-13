import 'package:app_links/app_links.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/deep_links/deep_links_controller.dart';
import 'package:workorder_company_app/core/services/deep_links/deep_links_service.dart';
import 'package:workorder_company_app/routes/app_router.dart';

Future<void> initDeepLinkFeature() async {
  sl.registerLazySingleton<AppLinks>(
    () => AppLinks(),
  );

  sl.registerLazySingleton<DeepLinkService>(
    () => DeepLinkService(
      sl<AppLinks>(),
    ),
  );

  sl.registerLazySingleton(
    () => PairCallbackDeepLinkHandler(
      router: appRouter,
    ),
  );

  sl.registerLazySingleton(
    () => const UnknownDeepLinkHandler(),
  );

  sl.registerLazySingleton(
    () => DeepLinkCoordinator(
      deepLinkService: sl(),
      pairCallbackHandler: sl(),
      unknownHandler: sl(),
    ),
  );
}
