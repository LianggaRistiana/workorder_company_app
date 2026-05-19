import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum FormType {
  intake,
  review,
  workOrder,
  report;

  static FormType fromString(String value) {
    switch (value) {
      case 'work_order':
        return FormType.workOrder;
      case 'report':
        return FormType.report;
      case 'review':
        return FormType.review;
      case 'intake':
        return FormType.intake;
      default:
        throw ParsingException('Unknown FormType: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

  String get displayName {
    switch (this) {
      case FormType.workOrder:
        return 'Perintah Kerja';
      case FormType.review:
        return 'Ulasan';
      case FormType.report:
        return 'Laporan';
      case FormType.intake:
        return 'Permintaan';
    }
  }

  @override
  String toString() => displayName;
}

enum FieldType {
  text,
  textarea,
  number,
  date,
  time,
  multiSelect,
  singleSelect,
  image,
  // file,
  // phone,
  email;

  static const availableType = {
    FieldType.text,
    FieldType.textarea,
    FieldType.number,
    FieldType.date,
    FieldType.multiSelect,
    FieldType.singleSelect,
    FieldType.image,
    FieldType.email,
  };

  static FieldType fromString(String value) {
    switch (value) {
      case 'text':
        return FieldType.text;
      case 'textarea':
        return FieldType.textarea;
      case 'number':
        return FieldType.number;
      case 'date':
        return FieldType.date;
      case 'time':
        return FieldType.time;
      case 'multi_select':
        return FieldType.multiSelect;
      case 'single_select':
        return FieldType.singleSelect;
      case 'email':
        return FieldType.email;
      case 'image':
        return FieldType.image;
      default:
        throw ParsingException('Unknown FieldType: $value');
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }

  String get displayName {
    switch (this) {
      case FieldType.text:
        return 'Text';
      case FieldType.email:
        return 'Email';
      case FieldType.textarea:
        return 'Paragraf';
      case FieldType.number:
        return 'Angka';
      case FieldType.date:
        return 'Date';
      case FieldType.time:
        return 'Time';
      case FieldType.image:
        return 'Gambar';
      case FieldType.multiSelect:
        return 'Pilihan Ganda';
      case FieldType.singleSelect:
        return 'Pilihan Tunggal';
    }
  }

  @override
  String toString() => displayName;
}
