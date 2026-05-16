import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class SamePositionRule extends AuthorizationRule {
  final PositionEntity? position;

  SamePositionRule(this.position);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final userPosition = user.position;
    final position = this.position;

    final isAllowed = userPosition != null &&
        position != null &&
        userPosition.id == position.id;

    return isAllowed
        ? AuthorizationResult.allowed()
        : AuthorizationResult.denied(
            "Departemen user tidak sesuai",
          );
  }
}

