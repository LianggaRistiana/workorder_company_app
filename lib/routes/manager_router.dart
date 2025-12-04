import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_actions_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/csr_detail_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/csr_page.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/manager_company_homepage.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_assigned_staff_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorder_detail_page.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorder_staff_config_page.dart';
import 'package:workorder_company_app/features/workorder/presentation/pages/workorders_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/manager_company_layout.dart';

final managerRouter = [
  ShellRoute(
      builder: (context, state, child) => ManagerCompanyLayout(child: child),
      routes: [
        GoRoute(
          path: '/manager',
          redirect: (_, __) => AppRoutes.home,
        ),
        GoRoute(
          path: AppRoutes.managerHome,
          builder: (_, __) => const ManagerCompanyHomepage(),
        ),
        GoRoute(
          path: AppRoutes.managerCsr,
          builder: (_, __) {
            return BlocProvider(
              create: (_) => sl<InternalCsrBloc>(),
              child: CsrPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.managerWorkorder,
          builder: (_, __) {
            return BlocProvider(
              create: (_) => sl<WorkorderBloc>(),
              child: WorkordersPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.managerProfile,
          builder: (_, __) => const ProfilePage(),
        ),
      ]),
  GoRoute(
    path: "${AppRoutes.managerCsr}/:id",
    builder: (context, state) {
      final id = state.pathParameters['id']!;

      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<InternalCsrDetailCubit>()..getCsrDetail(id),
          ),
          BlocProvider(
            create: (_) => sl<InternalCsrActionsCubit>(),
          ),
        ],
        child: CsrDetailPage(csrId: id),
      );
    },
  ),
  GoRoute(
    path: "${AppRoutes.managerWorkorder}/:id",
    builder: (_, state) {
      final id = state.pathParameters['id']!;
      return BlocProvider(
          create: (_) => sl<WorkorderDetailCubit>(),
          child: WorkorderDetailPage(workorderId: id));
    },
  ),
  GoRoute(
    path: "${AppRoutes.managerWorkorderStaffConfig}/:id",
    builder: (_, state) {
      final workorderId = state.pathParameters['id']!;
      final extras = state.extra as Map<String, dynamic>;

      final requiredStaff =
          extras['requiredStaff'] as List<RequiredStaffEntity>;

      final assignedStaff = extras['assignedStaff'] as List<UserEntity>;

      return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<WorkorderAssignedStaffCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<EmployeesBloc>(),
            ),
          ],
          child: WorkorderStaffConfigPage(
              workorderId: workorderId,
              assignedStaffs: assignedStaff,
              requiredStaff: requiredStaff));
    },
  ),
];
