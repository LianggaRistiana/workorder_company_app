import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/login_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/manager_company_homepage.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/owner_company_homepage.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/staff_company_homepage.dart';
import 'package:workorder_company_app/features/splash/splash_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/di/injection.dart';

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        redirect: (_, __) {
          final authRepo = sl<AuthRepository>();
          final user = authRepo.currentUser;

          if (user == null) return '/login';

          switch (user.role) {
            case UserRole.ownerCompany:
              return '/home/owner';
            case UserRole.managerCompany:
              return '/home/manager';
            case UserRole.staffCompany:
              return '/home/staff-company';
            case UserRole.staffUnssigned:
              return '/home/staff-unssigned';
          }
        },
        routes: [
          // Owner nested route
          GoRoute(
            path: 'owner',
            builder: (_, __) => const OwnerCompanyHomepage(),
            // routes: [
            // Contoh nested route untuk owner
            // GoRoute(path: 'employee', builder: (_, __) => EmployeePage()),
            // ],
          ),
          // Manager nested route
          GoRoute(
            path: 'manager',
            builder: (_, __) => const ManagerCompanyHomePage(),
          ),
          // Staff company nested route
          GoRoute(
            path: 'staff-company',
            builder: (_, __) => const StaffCompanyHomepage(),
          ),
          // Staff unassigned nested route
          GoRoute(
            path: 'staff-unssigned',
            builder: (_, __) => const StaffCompanyHomepage(),
          ),
        ],
      ),
    ]);



 // Owner nested route
    // ShellRoute(
    //   builder: (context, state, child) {
    //     return OwnerLayout(child: child); // Scaffold selalu ada, child isi berubah
    //   },
    //   routes: [
    //     GoRoute(
    //       path: 'owner',
    //       builder: (_, __) => const OwnerDashboardPage(),
    //     ),
    //     GoRoute(
    //       path: 'owner/employee',
    //       builder: (_, __) => const EmployeePage(),
    //     ),
    //   ],
    // ),