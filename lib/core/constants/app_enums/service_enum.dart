import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum ServiceRequestApprovalAccess {
  auto,
  manager;

  String get displayName {
    switch (this) {
      case ServiceRequestApprovalAccess.auto:
        return 'Otomatis';
      case ServiceRequestApprovalAccess.manager:
        return 'Manajer';
    }
  }

  static ServiceRequestApprovalAccess fromString(String value) {
    switch (value) {
      case 'auto':
        return ServiceRequestApprovalAccess.auto;
      case 'manager':
        return ServiceRequestApprovalAccess.manager;
      default:
        throw ParsingException('Unknown ServiceRequestApprovalAccess: $value');
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }
}

enum WorkOrderAprrovalAccess {
  auto,
  staffPic;

  String get displayName {
    switch (this) {
      case WorkOrderAprrovalAccess.auto:
        return 'Otomatis';
      case WorkOrderAprrovalAccess.staffPic:
        return 'Pegawai Bertanggung Jawab';
    }
  }

  static WorkOrderAprrovalAccess fromString(String value) {
    switch (value) {
      case 'auto':
        return WorkOrderAprrovalAccess.auto;
      case 'staff_pic':
        return WorkOrderAprrovalAccess.staffPic;
      default:
        throw ParsingException('Unknown WorkOrderAprrovalAccess: $value');
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }
}

enum WorkReportApprovalAccess {
  auto,
  manager;

  String get displayName {
    switch (this) {
      case WorkReportApprovalAccess.auto:
        return 'Otomatis';
      case WorkReportApprovalAccess.manager:
        return 'Manajer';
    }
  }

  static WorkReportApprovalAccess fromString(String value) {
    switch (value) {
      case 'auto':
        return WorkReportApprovalAccess.auto;
      case 'manager':
        return WorkReportApprovalAccess.manager;
      default:
        throw ParsingException('Unknown WorkReportApprovalAccess: $value');
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }
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
        throw ParsingException('Unknown TypeAccess: $value');
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
        return 'Publik';
      case ServiceAccessType.memberOnly:
        return 'Hanya Langganan';
      case ServiceAccessType.internal:
        return 'Internal';
    }
  }

  @override
  String toString() => displayName;
}

enum ServiceListNextAction {
  serviceDetail,
  createServiceRequest,
  createWorkOrder;
}
