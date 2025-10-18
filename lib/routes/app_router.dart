import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/routes/common_router.dart';
import 'package:workorder_company_app/routes/owner_router.dart';

final authBloc = sl<AuthBloc>();

final GoRouter appRouter = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
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
            default:
              return '/login';
          }
        },
      ),
      ...commonRouter,
      ...ownerRouter,



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
