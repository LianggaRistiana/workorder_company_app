/// Helper untuk menggabungkan banyak boolean function
class RuleEvaluator {
  /// Semua function harus true → AND
  static bool all(List<bool Function()> rules) {
    return rules.every((rule) => rule());
  }

  /// Minimal satu function true → OR
  static bool any(List<bool Function()> rules) {
    return rules.any((rule) => rule());
  }
}