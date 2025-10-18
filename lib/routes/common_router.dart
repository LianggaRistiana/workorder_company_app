

import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/login_page.dart';
import 'package:workorder_company_app/features/splash/splash_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final commonRouter = [
  GoRoute(
    path: AppRoutes.login,
    builder: (_, __) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.splash,
    builder: (_, __) => const SplashPage(),
  ),
];