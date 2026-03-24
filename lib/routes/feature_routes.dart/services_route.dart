import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/services/presentation/pages/services_list_page.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/pages/service_create/service_create_page.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/pages/service_detail/service_detail_page.dart';
// import 'package:workorder_company_app/features/services_legacy/presentation/pages/services/services_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final serviceRoute = [
  GoRoute(
    path: AppRoutes.services,
    builder: (_, __) => const ServicesListPage(),
  ),
  GoRoute(
    path: AppRoutes.servicesCreate,
    builder: (_, __) => const ServiceCreatePage(),
    // builder: (_, __) => const CreateServicePage(),
  ),
  GoRoute(
    path: AppRoutes.servicesDetail,
    builder: (_, state) {
      final id = state.pathParameters['id']!;
      return ServiceDetailPage(
        serviceId: id,
      );
    },
  ),
];
