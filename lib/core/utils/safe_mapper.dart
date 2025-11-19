import 'package:logger/logger.dart';

class SafeMapper {
  static List<T> mapList<T>(
    List<dynamic>? source,
    T? Function(Map<String, dynamic> json) fromJson) {
    if (source == null) return [];

    final result = <T>[];
    int skipped = 0;
    List<String> error = [];


    for (final item in source) {
      if (item is Map<String, dynamic>) {
        try {
          final parsed = fromJson(item);
          if (parsed != null) {
            result.add(parsed);
          } else {
            skipped++;
          }
        } catch (e) {
          error.add("${e.toString()}\n");
          skipped++;
        }
      } else {
        skipped++;
      }
    }

    if (skipped > 0) {
      Logger().f('$skipped $T item skipped during parsing.\nError :\n$error');
    }

    return result;
  }
}
