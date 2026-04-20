import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum WorkReportStatus {
  onProgress,
  sent,
  approved,
  rejected,
  cancelled; // TODO : concider to remove this status

  static WorkReportStatus fromString(String value) {
    return switch (value) {
      'on_progress' => WorkReportStatus.onProgress,
      'sent' => WorkReportStatus.sent,
      'approved' => WorkReportStatus.approved,
      'rejected' => WorkReportStatus.rejected,
      'cancelled' => WorkReportStatus.cancelled,
      _ => throw Exception('Unknown WorkReportStatus: $value'),
    };
  }
}

extension WorkReportStatusX on WorkReportStatus {
  String get toJsonString => name.toSnakeCase();

  String get displayName {
    return switch (this) {
      WorkReportStatus.onProgress => 'Dalam Pengerjaan',
      WorkReportStatus.sent => 'Dikirim',
      WorkReportStatus.approved => 'Disetujui',
      WorkReportStatus.rejected => 'Ditolak',
      WorkReportStatus.cancelled => 'Dibatalkan',
    };
  }
}
