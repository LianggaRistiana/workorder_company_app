import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_review_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_detail_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/page/not_found_page.dart';
// import 'package:workorder_company_app/shared/page/not_found_page.dart';

// TODO : give permission later
final serviceRequestRoute = [
  GoRoute(
    path: AppRoutes.serviceRequestSent,
    builder: (_, __) => RequesterServiceRequestListPage(),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestInbox,
    builder: (_, __) => NotFoundPage(),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestReview,
    builder: (_, state) => RequesterReviewPage(
      request: state.extra as RequesterServiceRequestEntity,
    ),
  ),
  GoRoute(
      path: AppRoutes.serviceRequestDetail,
      builder: (_, state) {
        return RequesterServiceRequestDetailPage(
          id: state.pathParameters['id']!,
        );
      }),
];
