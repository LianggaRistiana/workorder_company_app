import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/companies_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/client_homepage.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/client_layout.dart';

final clientRouter = [
  ShellRoute(
    builder: (context, state, child) => ClientLayout(child: child),
    routes: [
      GoRoute(
        path: '/client',
        redirect: (_, __) => AppRoutes.home,
      ),
      GoRoute(
        path: AppRoutes.clientHome,
        builder: (_, __) => const ClientHomepage(),
      ),
      GoRoute(
        path: AppRoutes.clientCompanyPortal,
        builder: (_, __) => const CompaniesPage(),
      ),
      GoRoute(
        path: AppRoutes.clientProfile,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  )
];
