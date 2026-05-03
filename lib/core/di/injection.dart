import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/core/services/cache/cache_injection.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/storage/token_storage.dart';
import 'package:workorder_company_app/features/auth/auth_injection.dart';
import 'package:workorder_company_app/features/faq/faq_injection.dart';
import 'package:workorder_company_app/features/service_request/service_request_injection.dart';
import 'package:workorder_company_app/features/company/company_injection.dart';
import 'package:workorder_company_app/features/employees/employees_injection.dart';
import 'package:workorder_company_app/features/forms/forms_injections.dart';
import 'package:workorder_company_app/features/invitations/invitations_injection.dart';
import 'package:workorder_company_app/features/memberships/memberships_injection.dart';
import 'package:workorder_company_app/features/notification/notification_injection.dart';
import 'package:workorder_company_app/features/positions/positions_injections.dart';
import 'package:workorder_company_app/features/services/services_injection.dart';
import 'package:workorder_company_app/features/submissions/submissions_injection.dart';
import 'package:workorder_company_app/features/template_config/template_config_injection.dart';
import 'package:workorder_company_app/features/work_order/work_order_injection.dart';
import 'package:workorder_company_app/features/work_report/work_report_injection.dart';

/// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  /// Core
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<ApiClient>(() => DioApiClient(tokenStorage: sl()));
  await initSubmissionsFeature();

  /// General Feature
  await initAuthFeature();
  await initNotificationFeature();

  /// Company Feature
  await initCompanyFeature();
  await initMembershipsFeature();
  await initFaqFeature();

  /// Human Resource Feature
  await initPositionsFeature();
  await initEmployeesFeature();
  await initInvitationsFeature();

  /// Service Feature
  await initFormsFeature();
  await initServicesFeature();

  /// Work Order Trilogy Feature
  await initServiceRequestFeature();
  await initWorkOrderFeature();
  await initWorkReportFeature();

  /// Template feature
  await initTemplateConfigFeature();

  // Cache
  await initCacheService();
}
