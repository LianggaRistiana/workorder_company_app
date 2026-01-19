import 'package:go_router/go_router.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/di/injection.dart';
// import 'package:workorder_company_app/routes/client_router.dart';
import 'package:workorder_company_app/routes/common_router.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/employees_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/home_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/positions_route.dart';
import 'package:workorder_company_app/routes/feature_routes.dart/workorders_route.dart';
import 'package:workorder_company_app/routes/guards/auth_guard.dart';
// import 'package:workorder_company_app/routes/manager_router.dart';
// import 'package:workorder_company_app/routes/owner_router.dart';
// import 'package:workorder_company_app/routes/staff_router.dart';
import 'package:workorder_company_app/shared/layout/app_layout.dart';

final authBloc = sl<AuthBloc>();

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) => AuthGuard.redirect(
        state.matchedLocation), // Remove this for old version
    routes: [
      ShellRoute(
          builder: (context, state, child) {
            return AppLayout(child: child);
          },
          routes: [
            ...homeRouter,
            ...positionsRouter,
            ...employeesRouter,
            ...workorderRouter
          ]),
      ...commonRouter,
      GoRoute(
        path: "/",
        redirect: (context, state) => AppRoutes.home,
      )
    ]);



// final GoRouter appRouter = GoRouter(initialLocation: AppRoutes.home, routes: [
//   GoRoute(
//     path: AppRoutes.home,
//     redirect: (_, __) {
//       final authRepo = sl<AuthRepository>();
//       final user = authRepo.currentUser;

//       if (user == null) return AppRoutes.login;

//       switch (user.role) {
//         case UserRole.ownerCompany:
//           return AppRoutes.ownerHome;
//         case UserRole.managerCompany:
//           return AppRoutes.managerHome;
//         case UserRole.staffCompany:
//           return AppRoutes.staffHome;
//         case UserRole.staffUnassigned:
//           return '/home/staff-unssigned';
//         case UserRole.client:
//           return AppRoutes.clientHome;
//       }
//     },
//   ),
//   ...commonRouter,
//   ...ownerRouter,
//   ...clientRouter,
//   ...managerRouter,
//   ...staffRouter
// ]);