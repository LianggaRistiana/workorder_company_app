import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/cache/cache_registry.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

Future<void> initCacheService() async {
  sl.registerLazySingleton<CacheRegistry>(
    () => CacheRegistry([
      sl<NotificationRepository>(),
      sl<WorkOrderRepository>(),
    ]),
  );
}
