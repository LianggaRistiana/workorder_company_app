import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/cache/cache_registry.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';
import 'package:workorder_company_app/features/employees/domain/repositories/employees_repository.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

Future<void> initCacheService() async {
  sl.registerLazySingleton<CacheRegistry>(
    () => CacheRegistry([
      // Auth, Internal Company, Employeess and Notification is not streamable repository
      sl<AuthRepository>(),
      sl<NotificationRepository>(),
      sl<InternalCompanyRepository>(),
      sl<EmployeesRepository>(),

      sl<PositionsRepository>(),
      sl<FormsRepository>(),
      sl<ServicesRepository>(),
      
      sl<RequesterServiceRequestRepository>(),

      // sl.<ProviderServiceRequestRepository>(),

      sl<WorkOrderRepository>(),
    ]),
  );
}
