enum ValidatorType {
  required,
  email,
  phone,
  password,
  number,
  minLength,
  maxLength,
  match,
  minValue,
  maxValue,
}

class ValidatorUtils {
  /// ✅ General-purpose validator untuk beberapa rule sekaligus
  static String? validate(
    String? value,
    List<ValidatorType> types, {
    int? minLength,
    int? maxLength,
    String? matchValue,
    double? minValue,
    double? maxValue,
    String fieldName = "Field",
  }) {
    for (var type in types) {
      final result = _validateSingle(
        value,
        type,
        minLength: minLength,
        maxLength: maxLength,
        matchValue: matchValue,
        fieldName: fieldName,
        minValue: minValue,
        maxValue: maxValue,
      );
      if (result != null) return result;
    }
    return null;
  }

  /// ✅ Shortcut untuk satu jenis validator (lebih ringkas)
  static String? single(
    String? value,
    ValidatorType type, {
    int? minLength,
    int? maxLength,
    double? minValue,
    double? maxValue,
    String? matchValue,
    String fieldName = "Field",
  }) {
    return _validateSingle(
      value,
      type,
      minLength: minLength,
      maxLength: maxLength,
      minValue: minValue,
      maxValue: maxValue,
      matchValue: matchValue,
      fieldName: fieldName,
    );
  }

  /// 🔒 Private function: handle 1 jenis validator
  static String? _validateSingle(
    String? value,
    ValidatorType type, {
    int? minLength,
    int? maxLength,
    String? matchValue,
    double? minValue,
    double? maxValue,
    String fieldName = "Field",
  }) {
    switch (type) {
      case ValidatorType.required:
        if (value == null || value.trim().isEmpty) {
          return "$fieldName tidak boleh kosong";
        }
        break;

      case ValidatorType.email:
        final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (value != null && !regex.hasMatch(value.trim())) {
          return "Format email tidak valid";
        }
        break;

      case ValidatorType.phone:
        final regex = RegExp(r'^\+?[\d\s-]{8,15}$');
        if (value != null && !regex.hasMatch(value.trim())) {
          return "Nomor telepon tidak valid";
        }
        break;

      case ValidatorType.password:
        if (value != null && value.length < 6) {
          return "Password minimal 6 karakter";
        }
        break;

      case ValidatorType.number:
        if (value != null && double.tryParse(value) == null) {
          return "$fieldName harus berupa angka";
        }
        break;

      case ValidatorType.minLength:
        if (minLength != null && (value == null || value.length < minLength)) {
          return "$fieldName minimal $minLength karakter";
        }
        break;

      case ValidatorType.maxLength:
        if (maxLength != null && (value != null && value.length > maxLength)) {
          return "$fieldName maksimal $maxLength karakter";
        }
        break;

      case ValidatorType.match:
        if (matchValue != null && value != matchValue) {
          return "$fieldName tidak cocok";
        }
        break;
      case ValidatorType.minValue:
        if (value != null && double.tryParse(value) != null) {
          final number = double.parse(value);
          if (minValue != null && number < minValue) {
            return "$fieldName minimal $minValue";
          }
        }
        break;

      case ValidatorType.maxValue:
        if (value != null && double.tryParse(value) != null) {
          final number = double.parse(value);
          if (maxValue != null && number > maxValue) {
            return "$fieldName maksimal $maxValue";
          }
        }
        break;
    }
    return null;
  }

  // 🚀 Shortcut helpers untuk cepat pakai di form
  static String? required(String? value, {String fieldName = "Field"}) =>
      single(value, ValidatorType.required, fieldName: fieldName);

  static String? email(String? value) =>
      single(value, ValidatorType.email, fieldName: "Email");

  static String? phone(String? value) =>
      single(value, ValidatorType.phone, fieldName: "Nomor Telepon");

  static String? number(String? value, {String fieldName = "Field"}) =>
      single(value, ValidatorType.number, fieldName: fieldName);

  static String? minLength(String? value, int min,
          {String fieldName = "Field"}) =>
      single(value, ValidatorType.minLength,
          minLength: min, fieldName: fieldName);

  static String? maxLength(String? value, int max,
          {String fieldName = "Field"}) =>
      single(value, ValidatorType.maxLength,
          maxLength: max, fieldName: fieldName);

  static String? match(String? value, String matchValue,
          {String fieldName = "Field"}) =>
      single(value, ValidatorType.match,
          matchValue: matchValue, fieldName: fieldName);
  static String? minValue(String? value, double min,
          {String fieldName = "Field"}) =>
      single(value, ValidatorType.minValue,
          minValue: min, fieldName: fieldName);

  static String? maxValue(String? value, double max,
          {String fieldName = "Field"}) =>
      single(value, ValidatorType.maxValue,
          maxValue: max, fieldName: fieldName);
}
