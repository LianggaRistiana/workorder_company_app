import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorder_detail_page.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorder_staff_config_page.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorder_submission_page.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorders_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/workorder_wrapper.dart';

final workorderRouter = [
  ShellRoute(
      builder: (context, state, child) {
        return WorkorderWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.workorders,
          builder: (_, __) => const WorkordersPage(),
        ),
        GoRoute(
          path: AppRoutes.workordersAssignStaff,
          builder: (_, state) {
            final workorderId = state.pathParameters['id']!;
            final extras = state.extra as Map<String, dynamic>;

            final requiredStaff =
                extras['requiredStaff'] as List<RequiredStaffEntity>;

            final assignedStaff = extras['assignedStaff'] as List<UserEntity>;

            return WorkorderStaffConfigPage(
                workorderId: workorderId,
                assignedStaffs: assignedStaff,
                requiredStaff: requiredStaff);
          },
        ),
        GoRoute(
          path: AppRoutes.workordersSubmission,
          builder: (_, __) => const WorkorderSubmissionPage(),
        ),
        GoRoute(
          path: AppRoutes.workordersDetail,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return WorkorderDetailPage(workorderId: id);
          },
        ),
      ]),
];
