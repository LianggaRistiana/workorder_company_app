/// A generic wrapper representing the outcome of a use case or repository call.
///
/// This class allows returning:
/// - the main [data]
/// - optional metadata through [meta]
/// - optional domain messages such as warnings or informational messages
///
/// The goal of this wrapper is to support cases where additional information
/// needs to accompany the primary data without modifying the entity itself.
///
/// Example usage:
///
/// ```dart
/// Result(
///   data: company,
///   messages: [
///     ResultMessage(
///       message: "Address belum diisi",
///       severity: ResultMessageSeverity.warning,
///     ),
///   ],
/// )
/// ```
///
/// Metadata such as pagination can also be included:
///
/// ```dart
/// Result(
///   data: employees,
///   meta: [
///     PaginationMeta(
///       page: 1,
///       total: 120,
///       totalPages: 12,
///     )
///   ],
/// )
/// ```
class Result<T> {
  /// The main data returned by the operation.
  final T data;

  /// Optional metadata attached to the result.
  ///
  /// Metadata can represent various types of additional information,
  /// such as pagination details, policy evaluation results, rate limits,
  /// or other contextual data.
  final List<ResultMeta> meta;


  const Result({
    required this.data,
    this.meta = const [],
  });

  /// Retrieves a metadata object of type [M] if it exists.
  ///
  /// This helper allows safely extracting metadata without manually
  /// iterating through the metadata list.
  ///
  /// Example:
  ///
  /// ```dart
  /// final pagination = result.getMeta<PaginationMeta>();
  /// ```
  M? getMeta<M extends ResultMeta>() {
    for (final m in meta) {
      if (m is M) return m;
    }
    return null;
  }
}

/// Base class for all metadata types that can be attached to a [Result].
///
/// Metadata represents additional contextual information related to the
/// returned data but does not belong to the domain entity itself.
///
/// Examples of metadata:
/// - Pagination information
/// - Policy evaluation results
/// - Rate limiting information
/// - Cache indicators
///
/// Each metadata type should extend this class.
abstract class ResultMeta {
  const ResultMeta();
}