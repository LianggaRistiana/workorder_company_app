import 'dart:math';

/// A helper utility for generating structured TODO placeholder strings
/// during UI development.
///
/// ------------------------------------------------------------
/// 🎯 Purpose
/// ------------------------------------------------------------
///
/// This class helps developers move fast when building UI
/// without immediately defining real strings inside feature
/// string files (e.g., AuthStrings).
///
/// Instead of hardcoding temporary text, you can generate
/// consistent TODO placeholders that are:
///
/// - Easy to identify
/// - Easy to search globally (`TODO_`)
/// - Structured and categorized
/// - Safe for refactoring later
///
/// ------------------------------------------------------------
/// 🧠 Why This Exists
/// ------------------------------------------------------------
///
/// When developing UI, constantly switching between:
/// - Widget file
/// - Feature string file
///
/// can break development flow.
///
/// `TodoText` allows you to:
/// 1. Quickly scaffold UI text
/// 2. Keep string formatting consistent
/// 3. Refactor safely before release
///
/// ------------------------------------------------------------
/// 🏷 Format Structure
/// ------------------------------------------------------------
///
/// Generated format:
///
///     TODO_<FEATURE>_<CATEGORY>_<KEY>
///
/// Example:
///
///     TODO_AUTH_VALIDATION_PASSWORD_REQUIRED
///
/// If feature is not provided, it defaults to:
///
///     GLOBAL
///
/// Example:
///
///     TODO_GLOBAL_ERROR_UNKNOWN
///
/// ------------------------------------------------------------
/// 📂 Recommended Usage
/// ------------------------------------------------------------
///
/// During feature development:
///
/// ```dart
/// Text(TodoText.validation("password_required", feature: "auth"));
/// ```
///
/// After feature is complete:
///
/// 1. Search globally for: `TODO_`
/// 2. Move all strings into appropriate feature string file
///    (e.g., AuthStrings)
/// 3. Replace usages with real string constants
///
/// ------------------------------------------------------------
/// ⚠ Important Notes
/// ------------------------------------------------------------
///
/// - This is a development helper only.
/// - TODO strings should not reach production.
/// - Always clean them up before release.
/// - Designed to support feature-first architecture.
///
/// ------------------------------------------------------------
/// 🏗 Architectural Boundary
/// ------------------------------------------------------------
///
/// This utility lives in:
///
///     core/utils/todo_text.dart
///
/// Because:
/// - It is generic
/// - It is UI-only concern
/// - It does not depend on domain or data layer
///
/// ------------------------------------------------------------
/// 💡 Categories Available
/// ------------------------------------------------------------
///
/// Error-related:
/// - error()
/// - validation()
/// - failure()
///
/// Success:
/// - success()
///
/// UI text:
/// - label()
/// - hint()
/// - title()
/// - subtitle()
/// - button()
/// - dialog()
/// - snackbar()
/// - message()
///
/// ------------------------------------------------------------
/// 🚀 Development Philosophy
/// ------------------------------------------------------------
///
/// This utility balances:
///
/// - Clean Architecture discipline
/// - Fast UI iteration
/// - Maintainable string management
///
/// It prevents random hardcoded text
/// while keeping development friction low.
class TodoText {
  static const _prefix = "TODO";
  static const _defaultFeature = "GLOBAL";
  static const List<String> _loremWords = [
    "lorem",
    "ipsum",
    "dolor",
    "sit",
    "amet",
    "consectetur",
    "adipiscing",
    "elit",
    "sed",
    "do",
    "eiusmod",
    "tempor",
    "incididunt",
    "ut",
    "labore",
    "et",
    "dolore",
    "magna",
    "aliqua"
  ];

  static String _generate({
    String? feature,
    required String category,
    required String key,
    int loremCount = 0,
  }) {
    final f = (feature ?? _defaultFeature).toUpperCase();
    final base =
        "${_prefix}_${f}_${category.toUpperCase()}_${key.toUpperCase()}";

    if (loremCount > 0) {
      return "$base • ${lorem(wordCount: loremCount)}";
    }
    return base;
  }

  static String lorem({int wordCount = 10}) {
    final random = Random();

    final words = List<String>.generate(
      wordCount,
      (_) => _loremWords[random.nextInt(_loremWords.length)],
    );

    if (words.isEmpty) return '';

    // Huruf pertama kapital + titik di akhir, pakai interpolation
    final text = '${words[0][0].toUpperCase()}${words[0].substring(1)}'
        '${words.sublist(1).join(' ')}.';

    return text;
  }

  // =============================
  // 🔥 ERROR
  // =============================
  static String error(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "ERROR",
          key: key,
          loremCount: loremCount);

  static String validation(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "VALIDATION",
          key: key,
          loremCount: loremCount);

  static String failure(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "FAILURE",
          key: key,
          loremCount: loremCount);

  // =============================
  // ✅ SUCCESS
  // =============================
  static String success(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "SUCCESS",
          key: key,
          loremCount: loremCount);

  // =============================
  // 🏷 UI TEXT
  // =============================
  static String label(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "LABEL",
          key: key,
          loremCount: loremCount);

  static String hint(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature, category: "HINT", key: key, loremCount: loremCount);

  static String title(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "TITLE",
          key: key,
          loremCount: loremCount);

  static String subtitle(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "SUBTITLE",
          key: key,
          loremCount: loremCount);

  static String button(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "BUTTON",
          key: key,
          loremCount: loremCount);

  static String dialog(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "DIALOG",
          key: key,
          loremCount: loremCount);

  static String snackbar(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "SNACKBAR",
          key: key,
          loremCount: loremCount);

  static String message(String key, {String? feature, int loremCount = 0}) =>
      _generate(
          feature: feature,
          category: "MESSAGE",
          key: key,
          loremCount: loremCount);
}
