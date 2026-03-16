/// A contract for components that maintain in-memory cache
/// and need explicit invalidation support.
///
/// Classes implementing [Cacheable] are expected to:
/// - Store temporary in-memory cached data
/// - Provide a mechanism to clear that cached state
///
/// This interface is typically implemented by:
/// - Repository implementations
/// - Data providers that use in-memory caching
///
/// It is commonly used together with a centralized
/// cache orchestration mechanism (e.g., CacheRegistry)
/// to perform bulk invalidation during events such as:
/// - User logout
/// - Session reset
/// - Role switching
///
/// Implementations should ensure that:
/// - Only in-memory state is cleared
/// - No persistent storage is modified unless explicitly intended
///
/// Example:
/// ```dart
/// class PositionRepositoryImpl
///     implements PositionRepository, Cacheable {
///
///   final CachedResource<List<Position>> _cache =
///       CachedResource(expiration: Duration(minutes: 10));
///
///   @override
///   void clearCache() {
///     _cache.clear();
///   }
/// }
/// ```
abstract class Cacheable {
  /// Clears all in-memory cached data held by the implementing class.
  ///
  /// This method should:
  /// - Reset any cached values
  /// - Remove timestamps or expiration metadata
  /// - Leave the object in a clean initial state
  ///
  /// This method should NOT:
  /// - Trigger remote calls
  /// - Throw exceptions
  /// - Modify unrelated state
  void clearCache();
}