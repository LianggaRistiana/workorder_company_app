import 'package:flutter/foundation.dart';

class SafeMapper {
  static List<T> mapList<T>(
    List<dynamic>? source,
    T? Function(Map<String, dynamic> json) fromJson) {
    if (source == null) return [];

    final result = <T>[];
    int skipped = 0;

    for (final item in source) {
      if (item is Map<String, dynamic>) {
        try {
          final parsed = fromJson(item);
          if (parsed != null) {
            result.add(parsed);
          } else {
            skipped++;
          }
        } catch (_) {
          skipped++;
        }
      } else {
        skipped++;
      }
    }

    if (skipped > 0) {
      debugPrint(
        '[SafeMapper] ⚠️ $skipped $T item skipped during parsing.',
      );
    }

    return result;
  }
}
