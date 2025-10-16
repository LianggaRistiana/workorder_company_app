extension StringCaseUtils on String {
  /// Convert camelCase or PascalCase to snake_case
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'(?<=[a-z0-9])[A-Z]'),
      (Match m) => '_${m.group(0)}',
    ).toLowerCase();
  }

  /// Convert camelCase or PascalCase to kebab-case
  String toKebabCase() {
    return replaceAllMapped(
      RegExp(r'(?<=[a-z0-9])[A-Z]'),
      (Match m) => '-${m.group(0)}',
    ).toLowerCase();
  }
}
