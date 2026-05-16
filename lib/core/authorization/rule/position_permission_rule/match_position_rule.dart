import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class MatchPositionRule extends AuthorizationRule {
  final PositionEntity? position;

  MatchPositionRule(this.position);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final userPosition = user.position;

    final isAllowed = userPosition?.id == position?.id;

    return isAllowed
        ? AuthorizationResult.allowed()
        : AuthorizationResult.denied(
            "Posisi tidak cocok",
          );
  }
}
