import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:workorder_company_app/core/services/cache/cached_resource.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';

/// A generic in-memory cache helper for list-based repositories.
///
/// Designed to be used via composition inside repository implementations.
/// This class is NOT intended to be extended.
///
/// Responsibilities:
/// - Fetch list data with TTL support
/// - Support force refresh
/// - Merge single entity (create/update)
/// - Remove single entity (delete)
/// - Manual invalidation
/// - Clear cache (e.g., logout)
///
/// This helper assumes:
/// - The repository is responsible for calling remote APIs
/// - ID comparison logic is provided via [idMatcher]
///
/// Example usage:
/// ```dart
/// final cache = ListCacheHelper<UserEntity>();
///
/// return cache.fetchList(
///   remoteCall: () => api.getUsers(),
/// );
/// ```
class ListCacheHelper<T> {
  final CachedResource<List<T>> _cache;

  /// Creates a new list cache helper.
  ///
  /// [expiration] defines how long the cached list remains valid.
  ListCacheHelper({Duration? expiration})
      : _cache = CachedResource<List<T>>(
          expiration: expiration ?? const Duration(minutes: 5),
        );

  /// Fetch list data with cache support.
  ///
  /// If cache is valid and [forceRefresh] is false,
  /// cached data is returned immediately.
  ///
  /// Otherwise, the [remoteCall] is executed.
  Future<Either<Failure, List<T>>> fetchList({
    required Future<List<T>> Function() remoteCall,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasValidValue) {
      debugPrint("Cache ${T.toString()} List Hit");
      return Right(_cache.value!);
    }

    final result = await safeCall(remoteCall);

    return result.map((data) {
      _cache.update(data);
      // HACK : observe this shit if someting goes wrong, this is return new list
      return List.of(data);
    });
  }

  /// Merge a single entity into the cached list.
  ///
  /// Used after successful create or update API calls.
  ///
  /// [idMatcher] must define how two entities are considered identical.
  void mergeSingle(
    T entity,
    bool Function(T a, T b) idMatcher,
  ) {
    if (!_cache.hasValidValue) return;

    final current = List<T>.from(_cache.value!);

    final index = current.indexWhere((e) => idMatcher(e, entity));

    if (index != -1) {
      current[index] = entity;
    } else {
      current.insert(0, entity);
    }

    _cache.update(current);
  }

  /// Remove a single entity from the cached list.
  ///
  /// Used after successful delete API calls.
  void removeSingle(
    T entity,
    bool Function(T a, T b) idMatcher,
  ) {
    if (!_cache.hasValidValue) return;

    final updated = _cache.value!.where((e) => !idMatcher(e, entity)).toList();

    _cache.update(updated);
  }

  /// Marks the cached list as expired.
  ///
  /// The next fetch will trigger a remote call.
  void invalidate() => _cache.invalidate();

  /// Completely clears the cache.
  ///
  /// Typically used during logout or session reset.
  void clear() => _cache.clear();

  /// Returns the current cached list if valid.
  List<T>? get value => _cache.value;

  void mapUpdate(T Function(T item) updater) {
    if (!_cache.hasValidValue) return;

    final updated = _cache.value!.map(updater).toList();
    _cache.update(updated);
  }
}
