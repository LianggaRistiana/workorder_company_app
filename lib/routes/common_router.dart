import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/chat_page.dart';
import 'package:workorder_company_app/features/notification/presentation/pages/notification_logs_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

final commonRouter = [
  GoRoute(
    path: AppRoutes.profile,
    builder: (_, __) => const ProfilePage(),
  ),
  GoRoute(
    path: AppRoutes.dashboard,
    builder: (_, __) => const DashboardPage(),
  ),
  GoRoute(
    path: AppRoutes.notifications,
    builder: (_, __) => const NotificationLogsPage(),
  ),
  GoRoute(
    path: AppRoutes.chatBot,
    redirect: requireExtra<CompanyEntity>(),
    builder: (_, state) => ChatPage(
      company: state.extra as CompanyEntity,
    ),
  ),
];
