/// Helper untuk menggabungkan banyak boolean function
class ConditionEvaluator {
  /// Semua function harus true → AND
  static bool all(List<bool Function()> logics) {
    return logics.every((logic) => logic());
  }

  /// Minimal satu function true → OR
  static bool any(List<bool Function()> logics) {
    return logics.any((logic) => logic());
  }
}

/// Shortcut untuk AND
bool allOf(List<bool Function()> logics) => ConditionEvaluator.all(logics);

/// Shortcut untuk OR
bool anyOf(List<bool Function()> logics) => ConditionEvaluator.any(logics);
