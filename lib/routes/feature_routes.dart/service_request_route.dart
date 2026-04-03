import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester_service_request_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final serviceRequestRoute = [
  GoRoute(
    path: AppRoutes.serviceRequestSend,
    builder: (_, __) => RequesterServiceRequestListPage(),
  ),
];
