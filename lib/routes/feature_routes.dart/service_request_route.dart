import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_detail_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

// TODO : give permission later
final serviceRequestRoute = [
  GoRoute(
    path: AppRoutes.serviceRequestSent,
    builder: (_, __) => RequesterServiceRequestListPage(),
  ),
  GoRoute(
      path: AppRoutes.serviceRequestDetail,
      builder: (_, state) {
        return RequesterServiceRequestDetailPage(
          id: state.pathParameters['id']!,
        );
      }),
];
