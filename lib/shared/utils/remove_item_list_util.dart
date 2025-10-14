extension RemoveAndReorderExtension<T> on List<T> {
  /// Remove an item and reassign order/index afterward.
  ///
  /// Example:
  /// ```dart
  /// selectedForms.removeWithCallback(item, (form, i) {
  ///   selectedForms[i] = form.copyWith(order: i + 1);
  /// });
  /// ```
  void removeWithCallback(
    T item,
    void Function(T item, int newIndex) onReordered,
  ) {
    remove(item);
    for (var i = 0; i < length; i++) {
      onReordered(this[i], i);
    }
  }
}
