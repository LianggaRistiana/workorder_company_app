import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum ServiceRequestStatus {
  received,
  cancelled,
  rejected,
  approved,
  onProgress,
  completed,
  closed;
  // FIXME : update status to fit with contract

  static ServiceRequestStatus fromString(String value) {
    return switch (value) {
      'received' => ServiceRequestStatus.received,
      'cancelled' => ServiceRequestStatus.cancelled,
      'rejected' => ServiceRequestStatus.rejected,
      'approved' => ServiceRequestStatus.approved,
      'on_progress' => ServiceRequestStatus.onProgress,
      'completed' => ServiceRequestStatus.completed,
      'closed' => ServiceRequestStatus.closed,
      _ => throw ParsingException('Unknown ServiceRequestStatus: $value'),
    };
  }
}

extension ServiceRequestStatusX on ServiceRequestStatus {
  String get displayName {
    return switch (this) {
      ServiceRequestStatus.received => 'Diterima',
      ServiceRequestStatus.cancelled => 'Dibatalkan',
      ServiceRequestStatus.rejected => 'Ditolak',
      ServiceRequestStatus.approved => 'Disetujui',
      ServiceRequestStatus.onProgress => 'Diproses',
      ServiceRequestStatus.completed => 'Selesai',
      ServiceRequestStatus.closed => 'Ditutup',
    };
  }

  String get toJsonString {
    return name.toSnakeCase();
  }
}

/// Used to identify the Service Request detail page in routing.
/// The same route is reused, but the displayed page depends on
/// the extra value provided through this enum.
enum ServiceRequestSide { provider, requester }
