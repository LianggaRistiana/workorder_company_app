class AuthorizationResult {
  final bool isAllowed;
  final String? message;

  const AuthorizationResult._(this.isAllowed, this.message);

  const AuthorizationResult.allowed() : this._(true, null);

  const AuthorizationResult.denied(String message) : this._(false, message);
}
