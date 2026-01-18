import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/login_page.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/common_page/forbidden_page.dart';

final commonRouter = [
  GoRoute(
    path: AppRoutes.login,
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.profile,
    builder: (_, __) => const ProfilePage(),
  ),
  GoRoute(
    path: '/forbidden',
    builder: (context, state) => const ForbiddenPage(),
  ),
];
