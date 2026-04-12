/// A generic wrapper representing the result of a use case or repository call.
///
/// This class enables returning:
/// - the primary [data]
/// - optional typed metadata via [meta]
///
/// The purpose of this wrapper is to allow additional contextual information
/// to accompany the main data without modifying the entity itself.
///
/// Metadata is stored using a type-based registry (`Map<Type, ResultMeta>`),
/// ensuring that only one metadata instance per type can exist.
///
/// This design supports flexible extensions such as:
/// - pagination details
/// - capability evaluations
/// - policy results
/// - domain-specific contextual data
///
/// Example usage:
///
/// ```dart
/// Result(
///   data: employees,
///   meta: {
///     PaginationMeta: PaginationMeta(
///       page: 1,
///       total: 120,
///       totalPages: 12,
///     ),
///   },
/// );
/// ```
///
/// Metadata can be retrieved in a type-safe manner:
///
/// ```dart
/// final pagination = result.getMeta<PaginationMeta>();
/// ```
class Result<T> {
  final T data;
  final Map<Type, ResultMeta> meta;

  const Result({
    required this.data,
    this.meta = const {},
  });

  M? getMeta<M extends ResultMeta>() {
    return meta[M] as M?;
  }
}

/// Base class for all metadata types that can be attached to a [Result].
///
/// Extend this class to define feature-specific or global metadata objects.
abstract class ResultMeta {
  const ResultMeta();
}
