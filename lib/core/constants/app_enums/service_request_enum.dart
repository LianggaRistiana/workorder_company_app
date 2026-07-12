import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum ServiceRequestStatus {
  received,
  cancelled,
  rejected,
  approved,
  onProgress,
  unProcessable,
  completed,
  partiallyCompleted,
  closed;

  static ServiceRequestStatus fromString(String value) {
    return switch (value) {
      'received' => ServiceRequestStatus.received,
      'cancelled' => ServiceRequestStatus.cancelled,
      'rejected' => ServiceRequestStatus.rejected,
      'approved' => ServiceRequestStatus.approved,
      'on_progress' => ServiceRequestStatus.onProgress,
      'completed' => ServiceRequestStatus.completed,
      'unprocessable' => ServiceRequestStatus.unProcessable,
      'partial_completed' => ServiceRequestStatus.partiallyCompleted,
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
      ServiceRequestStatus.unProcessable => 'Tidak bisa diproses',
      ServiceRequestStatus.partiallyCompleted => 'Selesai Sebagian',
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
enum ServiceRequestSide {
  provider,
  requester,
}

extension ServiceRequestStatusFlowX on ServiceRequestStatus {
  static const reviewAbleStates = {
    ServiceRequestStatus.completed,
    ServiceRequestStatus.partiallyCompleted,
    ServiceRequestStatus.closed,
  };

  static const workOrderAvailable = {
    ServiceRequestStatus.unProcessable,
    ServiceRequestStatus.approved,
    ServiceRequestStatus.completed,
    ServiceRequestStatus.onProgress,
    ServiceRequestStatus.partiallyCompleted,
    ServiceRequestStatus.closed,
  };

  static const reportAvailable = {
    ServiceRequestStatus.completed,
    ServiceRequestStatus.onProgress,
    ServiceRequestStatus.partiallyCompleted,
    ServiceRequestStatus.closed,
    };

  static const reviewAvailableStates = {
    ServiceRequestStatus.completed,
    ServiceRequestStatus.closed,
    ServiceRequestStatus.partiallyCompleted,
  };

  bool get isReviewAble => reviewAbleStates.contains(this);
  bool get isReviewAvailable => reviewAvailableStates.contains(this);
  bool get isReportAvailable => reportAvailable.contains(this);
  bool get isWorkOrderAvailable => workOrderAvailable.contains(this);
}
