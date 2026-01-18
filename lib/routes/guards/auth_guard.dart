import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/permisson/route_permissions.dart';

class AuthGuard {
  static String? redirect(String location) {
    final authRepo = sl<AuthRepository>();
    final user = authRepo.currentUser;

    // 1. Not logged in
    if (user == null) return AppRoutes.login;

    // 2. Permission check (if required)
    final permission = RoutePermissions.map[location];
    if (permission == null) return null;

    final allowed = user.role.canPermission(permission);

    return allowed ? null : AppRoutes.forbidden;
  }
}
