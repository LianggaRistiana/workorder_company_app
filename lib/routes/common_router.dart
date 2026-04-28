import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/notification/presentation/pages/notification_logs_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final commonRouter = [
  GoRoute(
    path: AppRoutes.profile,
    builder: (_, __) => const ProfilePage(),
  ),
  GoRoute(
    path: AppRoutes.notifications,
    builder: (_, __) => const NotificationLogsPage(),
  ),
];
