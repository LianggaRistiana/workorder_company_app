import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/provider/provider_service_request_detail_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/provider/provider_service_request_list_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_intake_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_review_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_detail_page.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/requester/requester_service_request_list_page.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

final serviceRequestRouter = [
  GoRoute(
    path: AppRoutes.serviceRequestSent,
    builder: (_, __) => RequesterServiceRequestListPage(),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestInbox,
    builder: (_, __) => ProviderServiceRequestListPage(),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestReview,
    builder: (_, state) => RequesterReviewPage(
      request: state.extra as RequesterServiceRequestEntity,
    ),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestCreate,
    builder: (_, state) => RequesterIntakePage(
      baseService: state.extra as BaseServiceEntity,
    ),
  ),
  GoRoute(
    path: AppRoutes.serviceRequestDetail,
    redirect: requireExtra<ServiceRequestSide>(),
    builder: (_, state) {
      final extra = state.extra as ServiceRequestSide;
      switch (extra) {
        case ServiceRequestSide.provider:
          return ProviderServiceRequestDetailPage(
            id: state.pathParameters['id']!,
          );
        case ServiceRequestSide.requester:
          return RequesterServiceRequestDetailPage(
            id: state.pathParameters['id']!,
          );
      }
    },
  ),
];
