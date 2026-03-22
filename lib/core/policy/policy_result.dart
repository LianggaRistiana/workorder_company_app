/// Defines the severity level of a policy evaluation result.
enum PolicySeverity {
  warning,
  error,
}

/// Represents the result of evaluating a business policy.
///
/// A policy evaluation can produce:
///
/// - **Valid**   → operation can continue
/// - **Warning** → operation can continue with notes
/// - **Error**   → operation must stop
///
/// The generic type [E] represents the domain-specific issue type.
class PolicyResult<E> {
  final E? issue;
  final PolicySeverity? severity;

  const PolicyResult._({
    this.issue,
    this.severity,
  });

  /// Creates a successful policy result.
  const PolicyResult.valid() : this._();

  /// Creates a warning policy result.
  const PolicyResult.warning(E issue)
      : this._(
          issue: issue,
          severity: PolicySeverity.warning,
        );

  /// Creates an error policy result.
  const PolicyResult.error(E issue)
      : this._(
          issue: issue,
          severity: PolicySeverity.error,
        );

  /// Returns `true` if the policy passed with no issue.
  bool get isValid => severity == null;

  /// Returns `true` if the policy produced a warning.
  bool get isWarning => severity == PolicySeverity.warning;

  /// Returns `true` if the policy produced an error.
  bool get isError => severity == PolicySeverity.error;
}