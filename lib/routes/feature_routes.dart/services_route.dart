import 'package:go_router/go_router.dart';
// import 'package:workorder_company_app/features/services/presentation/pages/create_new_service/create_new_service_page.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/pages/service_create/service_create_page.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/pages/service_detail/service_detail_page.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/pages/services/services_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/service_wrapper.dart';

final serviceRoute = [
  ShellRoute(
      builder: (context, state, child) {
        return ServiceWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.services,
          builder: (_, __) => const ServicesPage(),
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
      ])
];
