import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_create_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_detail_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_update_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/services_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final serviceRoute = [
  GoRoute(
    path: AppRoutes.services,
    builder: (_, state) {
      final extra = state.extra;
      if (extra is NextStepMode) {
        return ServicesListPage(
          nextStepMode: extra,
        );
      } else {
        return ServicesListPage();
      }
    },
  ),
  GoRoute(
    path: AppRoutes.servicesCreate,
    builder: (_, __) => const ServiceCreatePage(),
  ),
  GoRoute(
    path: AppRoutes.servicesUpdate,
    builder: (_, state) {
      final service = state.extra as ServiceEntity;
      return ServiceUpdatePage(
        serviceIntialData: service,
      );
    },
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
