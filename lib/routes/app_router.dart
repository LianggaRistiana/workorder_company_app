import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/login_page.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/company_page.dart';
import 'package:workorder_company_app/features/employees/presentation/page/employees_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/manager_company_homepage.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/owner_company_homepage.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/position_page.dart';
import 'package:workorder_company_app/shared/layout/manager_company_layout.dart';
import 'package:workorder_company_app/features/splash/splash_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/shared/layout/owner_company_layout.dart';

final authBloc = sl<AuthBloc>();

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.home,
    // refreshListenable: StreamRefreshNotifier(authBloc.stream),
    // redirect: (context, state) {
    //   final authState = context.read<AuthBloc>().state;
    //   // final authState = authBloc.state;

    //   // Hapus redirect dan refresh jika ingin menggunakan dari main
    //   Logger().i(authState);
    //   final location = state.uri.toString();

    //   if (authState is Unauthenticated) {
    //     return location == '/login' ? null : '/login';
    //   }

    //   if (authState is Authenticated) {
    //     if (location.startsWith('/home')) return null;
    //     return '/home';
    //   }
    //   return null;
    // },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        redirect: (_, __) {
          final authRepo = sl<AuthRepository>();
          final user = authRepo.currentUser;

          if (user == null) return AppRoutes.login;

          switch (user.role) {
            case UserRole.ownerCompany:
              return AppRoutes.ownerHome;
            case UserRole.managerCompany:
              return AppRoutes.login;
            case UserRole.staffCompany:
              return '/staff-company';
            case UserRole.staffUnssigned:
              return '/home/staff-unssigned';
          }
        },
      ),
      // Owner nested route
      ShellRoute(
        builder: (context, state, child) => OwnerCompanyLayout(child: child),
        routes: [
          GoRoute(
            path: '/owner',
            redirect: (_, __) => AppRoutes.home,
          ),
          GoRoute(
            path: AppRoutes.ownerHome,
            builder: (_, __) => const OwnerCompanyHomepage(),
          ),
          GoRoute(
            path: AppRoutes.ownerCompany,
            builder: (_, __) => const CompanyPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerEmployee,
            builder: (_, __) => const EmployeesPage(),
          ),
          GoRoute(
            path: AppRoutes.ownerProfile,
            builder: (_, __) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.ownerPositions,
            builder: (_, __) => const PositionsPage(),
          ),
        ],
      ),
      // Staff Company nested route
      ShellRoute(
        builder: (context, state, child) => ManagerCompanyLayout(child: child),
        routes: [
          GoRoute(
            path: '/staff-company',
            redirect: (_, __) => '/staff-company/home',
          ),
          GoRoute(
            path: '/staff-company/home',
            builder: (_, __) => const ProfilePage(),
          ),
          GoRoute(
            path: '/manager/profile',
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),
    ]);

// class StreamRefreshNotifier extends ChangeNotifier {
//   StreamRefreshNotifier(Stream<dynamic> stream) {
//     // pastikan stream broadcast kalau perlu, agar listen banyak kali aman
//     _subscription = stream.listen((_) => notifyListeners());
//   }

//   late final StreamSubscription<dynamic> _subscription;

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
