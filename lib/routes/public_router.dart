import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/login_page.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/register_common_page.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/register_company_page.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/register_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/page/forbidden_page.dart';
import 'package:workorder_company_app/shared/page/not_found_page.dart';

final publicRouter = [
  GoRoute(
    path: AppRoutes.login,
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.register,
    builder: (_, __) => const RegisterPage(),
  ),
  GoRoute(
    path: AppRoutes.registerCompany,
    builder: (_, __) => const RegisterCompanyPage(),
  ),
  GoRoute(
    path: AppRoutes.registerAccount,
    builder: (_, state) {
      final role = state.extra as UserRole;
      return RegisterCommonPage(role: role);
    },
  ),
  GoRoute(
    path: AppRoutes.forbidden,
    builder: (context, state) => const ForbiddenPage(),
  ),
  GoRoute(
    path: AppRoutes.notFound,
    builder: (context, state) => const NotFoundPage(),
  ),
];
