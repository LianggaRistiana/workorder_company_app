/// A simple reusable helper for reordering list items.
/// 
/// Example:
/// ```dart
/// selectedForms.reorder(oldIndex, newIndex);
/// ```
///
/// Optionally, you can use the version with callback if you need
/// to reassign an index/order field after reordering.
extension ReorderListExtension<T> on List<T> {
  /// Reorder a list in place.
  ///
  /// - [oldIndex] is the index of the item being moved.
  /// - [newIndex] is the target index.
  ///
  /// Example:
  /// ```dart
  /// items.reorder(oldIndex, newIndex);
  /// ```
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex < 0 || oldIndex >= length) return;
    if (newIndex < 0 || newIndex > length) return;

    if (newIndex > oldIndex) newIndex -= 1;
    final item = removeAt(oldIndex);
    insert(newIndex, item);
  }

  /// Reorder a list and run a callback after each item is moved,
  /// usually to update its index/order field.
  ///
  /// Example:
  /// ```dart
  /// selectedForms.reorderWithCallback(oldIndex, newIndex, (item, i) {
  ///   selectedForms[i] = item.copyWith(order: i + 1);
  /// });
  /// ```
  void reorderWithCallback(
    int oldIndex,
    int newIndex,
    void Function(T item, int newIndex) onReordered,
  ) {
    reorder(oldIndex, newIndex);

    for (var i = 0; i < length; i++) {
      onReordered(this[i], i);
    }
  }
}
