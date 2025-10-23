import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum UserRole {
  ownerCompany,
  managerCompany,
  staffCompany,
  staffUnssigned,
  client;

  static UserRole fromString(String value) {
    switch (value) {
      case 'owner_company':
        return UserRole.ownerCompany;
      case 'manager_company':
        return UserRole.managerCompany;
      case 'staff_company':
        return UserRole.staffCompany;
      case 'staff_unssigned':
        return UserRole.staffUnssigned;
      case 'client':
        return UserRole.client;
      default:
        throw Exception('Unknown UserRole: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

  /// Label yang ramah untuk ditampilkan di UI
  String get displayName {
    switch (this) {
      case UserRole.ownerCompany:
        return 'Owner';
      case UserRole.managerCompany:
        return 'Manager';
      case UserRole.staffCompany:
        return 'Staff';
      case UserRole.staffUnssigned:
        return 'Unassigned Staff';
      case UserRole.client:
        return 'Client';
    }
  }

  /// Override toString biar tampil human readable di UI juga
  @override
  String toString() => displayName;
}

enum ServiceAccessType {
  public,
  memberOnly,
  internal;

  static ServiceAccessType fromString(String value) {
    switch (value) {
      case 'public':
        return ServiceAccessType.public;
      case 'member_only':
        return ServiceAccessType.memberOnly;
      case 'internal':
        return ServiceAccessType.internal;
      default:
        throw Exception('Unknown TypeAccess: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

  String get displayName {
    switch (this) {
      case ServiceAccessType.public:
        return 'Public';
      case ServiceAccessType.memberOnly:
        return 'Member Only';
      case ServiceAccessType.internal:
        return 'Internal';
    }
  }

  @override
  String toString() => displayName;
}

enum FormType {
  intake,
  workOrder,
  report;

  static FormType fromString(String value) {
    switch (value) {
      case 'work_order':
        return FormType.workOrder;
      case 'report':
        return FormType.report;
      case 'intake':
        return FormType.intake;
      default:
        throw Exception('Unknown FormType: $value');
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
        return 'Work Order';
      case FormType.report:
        return 'Report';
      case FormType.intake:
        return 'Intake';
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
  singleSelect;

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
      default:
        throw Exception('Unknown FieldType: $value');
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }

  String toKebabCase() {
    return name.toKebabCase();
  }

  String get displayName {
    switch (this) {
      case FieldType.text:
        return 'Text';
      case FieldType.textarea:
        return 'Paragraf';
      case FieldType.number:
        return 'Angka';
      case FieldType.date:
        return 'Date';
      case FieldType.time:
        return 'Time';
      case FieldType.multiSelect:
        return 'Pilihan Ganda';
      case FieldType.singleSelect:
        return 'Pilihan Tunggal';
    }
  }

  @override
  String toString() => displayName;
}

enum SubmissionStatus {
  drafted,
  submitted,
  approved,
  rejected;
}

enum ClientServiceRequestStatus {
  received,
  cancelled,
  rejected,
  underReview,
  approved,
  workOrderCreated,
  completed
}

enum WorkOrderStatus { drafted, ready, inProgress, completed, cancelled }

enum WorkReportStatus { inProgress, completed, cancelled }

enum BlocState { initial, loading, loaded, error }
