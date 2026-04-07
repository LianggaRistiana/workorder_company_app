/// Represents the result of an authorization evaluation.
///
/// [AuthorizationResult] is returned by an [AuthorizationRule] after
/// evaluating whether a given user is allowed to perform a specific action.
///
/// It contains:
/// - [isAllowed]: Indicates whether the action is permitted.
/// - [message]: Optional explanation when access is denied.
///
/// This object is immutable and should be treated as a value object.
///
/// Example usage:
/// ```dart
/// final result = rule.evaluate(user);
///
/// if (result.isAllowed) {
///   // proceed with action
/// } else {
///   showSnackbar(result.message);
/// }
/// ```
class AuthorizationResult {
  final bool isAllowed;
  final String? message;

  const AuthorizationResult._(this.isAllowed, this.message);

  const AuthorizationResult.allowed() : this._(true, null);

  const AuthorizationResult.denied(String message) : this._(false, message);
}
