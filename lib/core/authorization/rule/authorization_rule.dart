import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'authorization_result.dart';

/// Represents a single authorization rule for an action.
///
/// Each [AuthorizationRule] defines one atomic access rule.
/// It evaluates whether a given [UserEntity] is allowed to perform an action.
///
/// This rule may depend on:
/// - User role & permissions
/// - Ownership
/// - Object state
/// - Contextual constraints
abstract class AuthorizationRule {
  AuthorizationResult evaluate(UserEntity user);
}