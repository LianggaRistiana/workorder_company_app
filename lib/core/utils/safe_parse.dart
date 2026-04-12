import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/error.dart';

T safeParse<T>(
  Map<String, dynamic> json,
  String path, {
  bool requiredField = true,
  T Function(dynamic value)? parser,
}) {
  try {
    dynamic current = json;

    for (var key in path.split('.')) {
      if (current is Map<String, dynamic>) {
        current = current[key];
      } else {
        throw ParsingException("Invalid structure: '$key' is not nested");
      }
    }

    if (current == null && requiredField) {
      throw ParsingException("Field '$path' is required but null");
    }

    if (current == null) {
      return current as T;
    }

    // 🔥 Transform dulu kalau ada parser
    final parsedValue = parser != null ? parser(current) : current;

    if (parsedValue is! T) {
      throw ParsingException(
        "Type mismatch at '$path'. Expected: $T, Found: ${parsedValue.runtimeType}",
      );
    }

    return parsedValue;
  } catch (e) {
    Logger().e(
      "Field Path : $path\n"
      "Expected   : $T\n"
      "Error      : $e",
    );
    throw ParsingException("Failed parsing field at '$path': $e");
  }
}

class JsonField {
  final Map<String, dynamic> json;
  final String path;

  JsonField(this.json, this.path);

  int reqInt() => safeParse<int>(json, path);
  String reqString() => safeParse<String>(json, path);
  double reqDouble() => safeParse<double>(json, path);
  bool reqBool() => safeParse<bool>(json, path);

  int? optInt() => safeParse<int?>(json, path, requiredField: false);
  String? optString() => safeParse<String?>(json, path, requiredField: false);

  Map<String, dynamic> reqMap() => safeParse<Map<String, dynamic>>(json, path);

  Map<String, dynamic>? optMap() =>
      safeParse<Map<String, dynamic>?>(json, path, requiredField: false);

  T req<T>({T Function(dynamic value)? parser}) =>
      safeParse<T>(json, path, parser: parser);

  T? opt<T>({T Function(dynamic value)? parser}) =>
      safeParse<T?>(json, path, requiredField: false, parser: parser);

  T reqModel<T>(T Function(Map<String, dynamic>) fromJson) {
    final map = safeParse<Map<String, dynamic>>(json, path);
    return fromJson(map);
  }

  T reqEnum<T>(
    T Function(String value) fromString,
  ) {
    return safeParse<T>(
      json,
      path,
      parser: (value) => fromString(value as String),
    );
  }

  T? optEnum<T>(
    T Function(String value) fromString,
  ) {
    return safeParse<T?>(
      json,
      path,
      requiredField: false,
      parser: (value) => fromString(value as String),
    );
  }

  List<T> reqListModel<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = safeParse<List<dynamic>>(json, path);

    return list.map((item) {
      if (item is! Map<String, dynamic>) {
        throw ParsingException(
          "Invalid list item at '$path', expected Map but got ${item.runtimeType}",
        );
      }
      return fromJson(item);
    }).toList();
  }

  List<T>? optListModel<T>(
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = safeParse<List<dynamic>?>(
      json,
      path,
      requiredField: false,
    );

    if (list == null) return null;

    return list.map((item) {
      if (item is! Map<String, dynamic>) {
        throw ParsingException(
          "Invalid list item at '$path', expected Map but got ${item.runtimeType}",
        );
      }
      return fromJson(item);
    }).toList();
  }

  DateTime? optDate() =>
      opt<DateTime>(parser: (v) => DateTime.parse(v as String));

  DateTime reqDate() =>
      req<DateTime>(parser: (v) => DateTime.parse(v as String));
}

extension JsonShortcut on Map<String, dynamic> {
  JsonField field(String path) => JsonField(this, path);
}
