/// Represents the result of evaluating a business policy.
///
/// This class is generic so it can be reused across multiple features.
/// The type parameter [E] represents the specific error type
/// defined inside each feature's domain.
///
/// If [error] is `null`, the policy check succeeded.
/// If [error] is not `null`, the policy check failed.
class PolicyResult<E> {
  /// The error produced by the policy.
  ///
  /// Will be `null` if the policy validation passed.
  final E? error;

  const PolicyResult._(this.error);

  /// Creates a successful policy result.
  const PolicyResult.valid() : this._(null);

  /// Creates a failed policy result with a specific [error].
  const PolicyResult.invalid(E error) : this._(error);

  /// Indicates whether the policy validation passed.
  bool get isValid => error == null;

  /// Indicates whether the policy validation failed.
  bool get isInvalid => error != null;
}