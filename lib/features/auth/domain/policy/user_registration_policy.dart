import 'package:workorder_company_app/core/policy/policy_result.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';

enum RegistrationError {
  roleNotAllowed,
}

class UserRegistrationPolicy {
  static const _allowedRoles = {UserRole.client, UserRole.staffUnassigned};

  PolicyResult<RegistrationError> validate(UserRegistrationEntity user) {
    if (!_allowedRoles.contains(user.role)) {
      return const PolicyResult.error(
        RegistrationError.roleNotAllowed,
      );
    }

    return const PolicyResult.valid();
  }
}
