import 'package:workorder_company_app/core/cache/cache_config.dart';

/// A lightweight in-memory cache wrapper for a single resource.
///
/// [CachedResource] stores a value of type [T] along with
/// its last update timestamp and handles expiration automatically.
///
/// This class is intended for:
/// - Short-lived in-memory caching
/// - Reducing repeated remote calls
/// - Session-scoped resource lifecycle
///
/// It is NOT intended for:
/// - Persistent storage
/// - Offline-first architecture
/// - Complex synchronization strategies
///
/// Example usage:
/// ```dart
/// final cache = CachedResource<List<User>>(
///   expiration: const Duration(minutes: 5),
/// );
///
/// if (cache.hasValidValue) {
///   return cache.value!;
/// }
///
/// final data = await api.getUsers();
/// cache.update(data);
/// return data;
/// ```
class CachedResource<T> {
  /// Defines how long the resource remains valid
  /// after the last successful update.
  final Duration expiration;

  T? _value;
  DateTime? _lastUpdated;

  /// Creates a new [CachedResource] with a required expiration duration.
  ///
  /// The resource is considered expired if:
  /// - It has no value
  /// - The expiration duration has passed
  CachedResource({
    this.expiration = CacheConfig.short,
  });

  /// Returns `true` if:
  /// - No value has been set, OR
  /// - The expiration duration has elapsed
  bool get isExpired {
    if (_value == null || _lastUpdated == null) return true;
    return DateTime.now().difference(_lastUpdated!) > expiration;
  }

  /// Returns `true` if a value exists and is NOT expired.
  bool get hasValidValue => _value != null && !isExpired;

  /// Returns the cached value only if it is still valid.
  ///
  /// Returns `null` if:
  /// - No value exists
  /// - The value is expired
  T? get value {
    if (hasValidValue) return _value;
    return null;
  }

  /// Updates the cached value and resets the expiration timer.
  ///
  /// This should typically be called after a successful
  /// remote fetch or computation.
  void update(T newValue) {
    _value = newValue;
    _lastUpdated = DateTime.now();
  }

  /// Marks the resource as expired without removing the value.
  ///
  /// Useful when:
  /// - A related mutation occurs (create/update/delete)
  /// - You want the next access to trigger a refresh
  void invalidate() {
    if (_value != null) {
      _lastUpdated = null;
    }
  }

  /// Completely clears the cached value and timestamp.
  ///
  /// This should typically be called during:
  /// - Logout
  /// - Session reset
  /// - Full cache invalidation
  void clear() {
    _value = null;
    _lastUpdated = null;
  }

  /// Returns the last update timestamp.
  ///
  /// Mainly useful for debugging or logging.
  DateTime? get lastUpdated => _lastUpdated;
}
