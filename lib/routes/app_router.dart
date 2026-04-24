import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/services/navigation/app_navigator_key.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/common_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/company_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/employees_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/forms_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/home_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/invitations_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/memberships_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/positions_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/service_request_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/services_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/work_order_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/work_report_route.dart';
import 'package:workorder_company_app/routes/guards/auth_guard.dart';
import 'package:workorder_company_app/shared/layout/app_layout.dart';
import 'package:workorder_company_app/shared/page/not_found_page.dart';

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: navigatorKey,
    redirect: (context, state) => AuthGuard.redirect(state.matchedLocation),
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return AppLayout(child: child);
          },
          routes: [
            ...homeRouter,
            ...companyRouter,
            ...positionsRouter,
            ...employeesRouter,
            ...formsRouter,
            ...serviceRoute,
            ...invitationsRoute,
            ...membershipsRoute,
            ...publicCompaniesRouter,
            ...serviceRequestRoute,
            ...workOrderRouter,
            ...workReportRoute
          ]),
      ...commonRouter,
      GoRoute(
        path: "/",
        redirect: (context, state) => AppRoutes.home,
      )
    ],
    errorBuilder: (context, state) => NotFoundPage());
