import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/staff_company_homepage.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/staff_company_layout.dart';

final staffRouter = [
  ShellRoute(
      builder: (context, state, child) => StaffCompanyLayout(child: child),
      routes: [
        GoRoute(
          path: '/staff',
          redirect: (_, __) => AppRoutes.home,
        ),
        GoRoute(
          path: AppRoutes.staffHome,
          builder: (_, __) => const StaffCompanyHomepage(),
        ),
        GoRoute(
          path: AppRoutes.staffHome,
          builder: (_, __) => const ProfilePage(),
        ),
      ])
];
