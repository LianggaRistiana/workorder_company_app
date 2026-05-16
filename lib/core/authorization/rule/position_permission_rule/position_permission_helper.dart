import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/different_position_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/has_position_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/no_position_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/same_position_rule.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

AuthorizationRule hasNoPosition() => NoPositionRule();

AuthorizationRule hasPosition() => HasPositionRule();

AuthorizationRule differentPosition(PositionEntity? position) =>
    DifferentPositionRule(position);

AuthorizationRule samePosition(PositionEntity? position) =>
    SamePositionRule(position);
