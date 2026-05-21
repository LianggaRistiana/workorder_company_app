import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/permisson/route_permissions.dart';

class AuthGuard {
  static String? redirect(String location) {
    final authRepo = sl<AuthRepository>();
    final user = authRepo.currentUser;

    const publicRoutes = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.registerCompany,
      AppRoutes.registerAccount,
    ];

    final isPublic = publicRoutes.contains(location);

    // 1️⃣ Kalau belum login
    if (user == null) {
      // kalau route public → boleh akses
      if (isPublic) return null;

      // selain itu → paksa ke login
      return AppRoutes.onBoarding;
    }

    // 2️⃣ Kalau sudah login tapi buka login/register lagi
    // if (isPublic) {
    //   return AppRoutes.home;
    // }

    // 3️⃣ Permission check
    final permission = RoutePermissions.map[location];
    if (permission == null) return null;

    final allowed = user.role.canPermission(permission);

    return allowed ? null : AppRoutes.forbidden;
  }
}
