import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/common_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/faq_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/service_price_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/system_integration_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/template_config_router.dart';
import 'package:workorder_company_app/routes/public_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/company_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/employees_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/forms_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/home_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/invitations_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/memberships_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/positions_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/service_request_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/service_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/work_order_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/work_report_router.dart';
import 'package:workorder_company_app/routes/guards/auth_guard.dart';
import 'package:workorder_company_app/shared/layout/app_layout.dart';
import 'package:workorder_company_app/shared/page/not_found_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    // final uri = state.uri.toString();
    appLogger.i(state.uri.toString());
    return AuthGuard.redirect(state.matchedLocation);
  },
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },
        routes: [
          ...homeRouter,
          ...companyRouter,
          ...templateConfigRouters,
          ...faqRouter,
          ...positionsRouter,
          ...employeesRouter,
          ...formsRouter,
          ...serviceRouter,
          ...servicePriceRouter,
          ...invitationsRouter,
          ...membershipsRouter,
          ...publicCompaniesRouter,
          ...serviceRequestRouter,
          ...workOrderRouter,
          ...workReportRouter,
          ...systemIntegrationRouter,
          ...commonRouter,
        ]),
    ...publicRouter,
    GoRoute(
      path: "/",
      redirect: (context, state) => AppRoutes.home,
    )
  ],
  errorBuilder: (context, state) => NotFoundPage(),
);
