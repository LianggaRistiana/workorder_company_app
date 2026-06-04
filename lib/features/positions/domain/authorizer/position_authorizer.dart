import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/meta/position_detail_meta.dart';

class PositionAuthorizer {
  final PositionEntity position;
  final PositionDetailMeta? meta;

  PositionAuthorizer({
    required this.position,
    this.meta,
  });

  AuthorizationRule get deleteRule => rules([
        roleCan(PositionsPermission.delete),
        _DeleteCapabilityRule(meta),
      ]);
}

class _DeleteCapabilityRule extends AuthorizationRule {
  final PositionDetailMeta? meta;

  _DeleteCapabilityRule(this.meta);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (meta?.canDelete == true) {
      return AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied("Tidak bisa menghapus departemen ini");
  }
}
