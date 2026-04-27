import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

/// A centralized orchestrator for clearing in-memory caches.
///
/// [CacheRegistry] coordinates bulk cache invalidation
/// across multiple components that implement [Cacheable].
///
/// This class is typically used during:
/// - User logout
/// - Session reset
/// - Role switching
/// - Security-sensitive state changes
///
/// It does NOT:
/// - Store cached data
/// - Perform caching logic
/// - Trigger network requests
///
/// It simply delegates cache clearing to registered components.
///
/// Example registration (with dependency injection):
///
/// ```dart
/// sl.registerLazySingleton<CacheRegistry>(() => CacheRegistry([
///   sl<PositionRepository>() as Cacheable,
///   sl<InvitationRepository>() as Cacheable,
/// ]));
/// ```
///
/// Example usage:
///
/// ```dart
/// await authRepository.logout();
/// cacheRegistry.clearAll();
/// ```
///
/// Design principle:
/// - Keep cache invalidation centralized
/// - Avoid spreading logout cleanup logic across multiple layers
class CacheRegistry {
  final List<Cacheable> _caches;

  /// Creates a [CacheRegistry] with a list of cacheable components.
  ///
  /// The provided list should contain only components
  /// responsible for managing in-memory cache.
  ///
  /// The registry does not validate types at runtime.
  /// Ensure that all items correctly implement [Cacheable].
  CacheRegistry(List<Cacheable> caches) : _caches = List.unmodifiable(caches);

  /// Clears all registered in-memory caches.
  ///
  /// This method:
  /// - Iterates through all registered [Cacheable] instances
  /// - Calls [Cacheable.clearCache] on each
  ///
  /// It should be safe to call multiple times.
  ///
  /// This method should NOT:
  /// - Throw exceptions
  /// - Trigger remote requests
  /// - Modify persistent storage
  void clearAll() {
    appLogger.d("Clearing all caches provide by CacheRegistry");
    for (final cache in _caches) {
      appLogger.d("Clearing cache ${cache.runtimeType}");
      cache.clearCache();
    }
  }
}
