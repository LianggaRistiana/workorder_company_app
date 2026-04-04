import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum UserRole {
  ownerCompany,
  managerCompany,
  staffCompany,
  staffUnassigned,
  client;

  static UserRole fromString(String value) {
    switch (value) {
      case 'owner_company':
        return UserRole.ownerCompany;
      case 'manager_company':
        return UserRole.managerCompany;
      case 'staff_company':
        return UserRole.staffCompany;
      case 'staff_unassigned':
        return UserRole.staffUnassigned;
      case 'client':
        return UserRole.client;
      default:
        throw ParsingException('Unknown UserRole: $value');
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
      case UserRole.staffUnassigned:
        return 'Unassigned Staff';
      case UserRole.client:
        return 'Client';
    }
  }

  String get routePrefix {
    switch (this) {
      case UserRole.ownerCompany:
        return 'owner';
      case UserRole.managerCompany:
        return 'manager';
      case UserRole.staffCompany:
        return 'staff';
      case UserRole.staffUnassigned:
        return 'unassigned-staff';
      case UserRole.client:
        return 'client';
    }
  }

  /// Override toString biar tampil human readable di UI juga
  @override
  String toString() => displayName;
}

enum InvitationStatus {
  pending,
  accepted,
  rejected,
  cancelled;

  String get displayName {
    switch (this) {
      case InvitationStatus.pending:
        return 'Pending';
      case InvitationStatus.accepted:
        return 'Diterima';
      case InvitationStatus.rejected:
        return 'Ditolak';
      case InvitationStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }

  static InvitationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return InvitationStatus.pending;
      case 'accepted':
        return InvitationStatus.accepted;
      case 'rejected':
        return InvitationStatus.rejected;
      case 'cancelled':
        return InvitationStatus.cancelled;
      default:
        throw ParsingException('Unknown InvitationStatus: $value');
    }
  }
}

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
        return 'Tugas Kerja';
      case FormType.report:
        return 'Laporan';
      case FormType.intake:
        return 'Pengajuan';
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
  // file,
  // phone,
  email;

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
      default:
        throw ParsingException('Unknown FieldType: $value');
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

  static SubmissionStatus fromString(String value) {
    switch (value) {
      case 'drafted':
        return SubmissionStatus.drafted;
      case 'submitted':
        return SubmissionStatus.submitted;
      case 'approved':
        return SubmissionStatus.approved;
      case 'rejected':
        return SubmissionStatus.rejected;
      default:
        throw ParsingException('Unknown SubmissionStatus: $value');
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
      case SubmissionStatus.drafted:
        return 'Draft';
      case SubmissionStatus.submitted:
        return 'Submitted';
      case SubmissionStatus.approved:
        return 'Approved';
      case SubmissionStatus.rejected:
        return 'Rejected';
    }
  }

  @override
  String toString() => displayName;
}

enum ServiceRequestStatus {
  received,
  cancelled,
  rejected,
  approved,
  workOrderCreated,
  completed;
  

  static ServiceRequestStatus fromString(String value) {
    switch (value) {
      case 'received':
        return ServiceRequestStatus.received;
      case 'cancelled':
        return ServiceRequestStatus.cancelled;
      case 'rejected':
        return ServiceRequestStatus.rejected;
      case 'approved':
        return ServiceRequestStatus.approved;
      case 'work_order_created':
        return ServiceRequestStatus.workOrderCreated;
      case 'completed':
        return ServiceRequestStatus.completed;
      default:
        throw ParsingException('Unknown ServiceRequestStatus: $value');
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
      case ServiceRequestStatus.received:
        return 'Menunggu';
      case ServiceRequestStatus.cancelled:
        return 'Dibatalkan';
      case ServiceRequestStatus.rejected:
        return 'Ditolak';
      case ServiceRequestStatus.approved:
        return 'Disetujui';
      case ServiceRequestStatus.workOrderCreated:
        return 'Diproses';
      case ServiceRequestStatus.completed:
        return 'Selesai';
    }
  }

  @override
  String toString() => displayName;
}

// TODO : remove this later
enum ClientServiceRequestStatus {
  received,
  cancelled,
  rejected,
  approved,
  workOrderCreated,
  completed;

  static ClientServiceRequestStatus fromString(String value) {
    switch (value) {
      case 'received':
        return ClientServiceRequestStatus.received;
      case 'cancelled':
        return ClientServiceRequestStatus.cancelled;
      case 'rejected':
        return ClientServiceRequestStatus.rejected;
      case 'approved':
        return ClientServiceRequestStatus.approved;
      case 'work_order_created':
        return ClientServiceRequestStatus.workOrderCreated;
      case 'completed':
        return ClientServiceRequestStatus.completed;
      default:
        throw ParsingException('Unknown ClientServiceRequestStatus: $value');
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
      case ClientServiceRequestStatus.received:
        return 'Menunggu';
      case ClientServiceRequestStatus.cancelled:
        return 'Dibatalkan';
      case ClientServiceRequestStatus.rejected:
        return 'Ditolak';
      case ClientServiceRequestStatus.approved:
        return 'Disetujui';
      case ClientServiceRequestStatus.workOrderCreated:
        return 'Diproses';
      case ClientServiceRequestStatus.completed:
        return 'Selesai';
    }
  }

  @override
  String toString() => displayName;
}

enum WorkOrderStatus {
  drafted,
  ready,
  inProgress,
  completed,
  cancelled;

  static WorkOrderStatus fromString(String value) {
    switch (value) {
      case 'drafted':
        return WorkOrderStatus.drafted;
      case 'ready':
        return WorkOrderStatus.ready;
      case 'in_progress':
        return WorkOrderStatus.inProgress;
      case 'completed':
        return WorkOrderStatus.completed;
      case 'cancelled':
        return WorkOrderStatus.cancelled;
      default:
        throw ParsingException('Unknown WorkOrderStatus: $value');
    }
  }

  String get displayName {
    switch (this) {
      case WorkOrderStatus.drafted:
        return 'Draft';
      case WorkOrderStatus.ready:
        return 'Siap';
      case WorkOrderStatus.inProgress:
        return 'Diproses';
      case WorkOrderStatus.completed:
        return 'Selesai';
      case WorkOrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}

enum WorkReportStatus { inProgress, completed, cancelled }

enum BlocState { initial, loading, loaded, error }
