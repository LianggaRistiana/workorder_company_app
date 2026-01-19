/// Extension helper to easily replace the `:id` placeholder in route strings.
extension RouteHelper on String {
  /// Replaces `:id` in the route with the given value.
  ///
  /// Example:
  /// ```dart
  /// String route = AppRoutes.positionsDetail; // "/positions/:id"
  /// String finalRoute = route.fillId('123');   // "/positions/123"
  /// ```
  ///
  /// [id] The value that will replace `:id` in the route.
  String fillId(String id) {
    return replaceAll(':id', id);
  }
}
