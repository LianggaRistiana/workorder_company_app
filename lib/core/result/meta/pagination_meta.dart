import 'package:workorder_company_app/core/result/result.dart';

/// Metadata representing pagination information for list responses.
///
/// This metadata is typically used when retrieving paginated data
/// from an API or repository.
///
/// Example:
///
/// ```dart
/// Result(
///   data: employees,
///   meta: [
///     PaginationMeta(
///       page: 1,
///       total: 100,
///       totalPages: 10,
///     ),
///   ],
/// )
/// ```
class PaginationMeta extends ResultMeta {
  /// The current page number.
  final int page;

  /// The total number of items available.
  final int total;

  /// The total number of available pages.
  final int totalPages;

  const PaginationMeta({
    required this.page,
    required this.total,
    required this.totalPages,
  });
}
