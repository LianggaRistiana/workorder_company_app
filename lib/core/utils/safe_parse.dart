import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/error.dart';

// T safeParse<T>(
//   Map<String, dynamic> json,
//   String path, {
//   bool requiredField = true,
// }) {
//   try {
//     dynamic current = json;

//     // support nested path seperti "profile.address.city"
//     for (var key in path.split('.')) {
//       if (current is Map<String, dynamic>) {
//         current = current[key];
//       } else {
//         throw ParsingException("Invalid structure: '$key' is not nested");
//       }
//     }

//     // Jika null tapi field wajib → error
//     if (current == null && requiredField) {
//       throw ParsingException("Field '$path' is required but null");
//     }

//     // Jika null dan field opsional → return null
//     if (current == null) {
//       return current as T; // T boleh nullable di pemanggilan
//     }

//     // Cek tipe apakah sesuai T
//     if (current is! T) {
//       throw ParsingException(
//         "Type mismatch at '$path'. Expected: $T, Found: ${current.runtimeType}",
//       );
//     }

//     return current;
//   } catch (e) {
//     Logger().e(
//         "Field Path : $path\n"
//         "Expected   : $T\n"
//         "Error      : $e");
//     throw ParsingException("Failed parsing field at '$path': $e");
//   }
// }

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
