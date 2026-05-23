import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum WorkOrderStatus {
  drafted,
  sent,
  approved,
  rejected,
  cancelled,
  onProgress,
  completed,
  failed;

  // NOTE : Since all work order is auto approved, approveed WO counted as sent
  static WorkOrderStatus fromString(String value) {
    return switch (value) {
      'drafted' => WorkOrderStatus.drafted,
      'sent' => WorkOrderStatus.sent,
      'approved' => WorkOrderStatus.sent,
      'rejected' => WorkOrderStatus.rejected,
      'on_progress' => WorkOrderStatus.onProgress,
      'completed' => WorkOrderStatus.completed,
      'cancelled' => WorkOrderStatus.cancelled,
      'failed' => WorkOrderStatus.failed,
      _ => throw Exception('Unknown WorkOrderStatus: $value'),
    };
  }

  static const availableStatus = [
    WorkOrderStatus.drafted,
    WorkOrderStatus.sent,
    // WorkOrderStatus.approved,
    // WorkOrderStatus.rejected,
    WorkOrderStatus.onProgress,
    WorkOrderStatus.cancelled,
    WorkOrderStatus.completed,
    WorkOrderStatus.failed
  ];
}

extension WorkOrderStatusFlowStateX on WorkOrderStatus {
  static const finalStates = {
    WorkOrderStatus.completed,
    WorkOrderStatus.failed,
    WorkOrderStatus.cancelled,
  };

  static const cancellableStates = {
    WorkOrderStatus.drafted,
    WorkOrderStatus.approved,
    WorkOrderStatus.sent,
    WorkOrderStatus.rejected,
  };

  static const initialParams = {
    WorkOrderStatus.drafted,
    WorkOrderStatus.onProgress,
    WorkOrderStatus.sent,
  };

  static const reportableStates = {
    WorkOrderStatus.completed,
    WorkOrderStatus.failed,
    WorkOrderStatus.onProgress,
  };

  static const notStartedStates = {
    WorkOrderStatus.drafted,
    WorkOrderStatus.sent,
    WorkOrderStatus.approved,
  };

  static const reviewedStates = {
    WorkOrderStatus.approved,
    WorkOrderStatus.rejected
  };

  bool get isCancellable => cancellableStates.contains(this);

  bool get isReportable => reportableStates.contains(this);

  bool get isFinal => finalStates.contains(this);

  bool get isReviewed => reviewedStates.contains(this);

  bool get isNotStarted => notStartedStates.contains(this);

  bool get isActive => this == WorkOrderStatus.onProgress;

  static List<WorkOrderStatus> get finalStatesList => finalStates.toList();

  static List<WorkOrderStatus> get cancellableStatesList =>
      cancellableStates.toList();

  static List<WorkOrderStatus> get reportableStatesList =>
      reportableStates.toList();

  static List<WorkOrderStatus> get notStartedStatesList =>
      notStartedStates.toList();

  static List<WorkOrderStatus> get reviewedStatesList =>
      reviewedStates.toList();

  static List<WorkOrderStatus> get initialParamsList => initialParams.toList();
}

extension WorkOrderStatusX on WorkOrderStatus {
  String get toJsonString {
    return name.toSnakeCase();
  }

  String get displayName {
    return switch (this) {
      WorkOrderStatus.drafted => 'Disusun',
      WorkOrderStatus.sent => 'Dikirim',
      WorkOrderStatus.approved => 'Disetujui',
      WorkOrderStatus.rejected => 'Ditolak',
      WorkOrderStatus.onProgress => 'Dalam Proses',
      WorkOrderStatus.completed => 'Selesai',
      WorkOrderStatus.cancelled => 'Dibatalkan',
      WorkOrderStatus.failed => 'Gagal',
    };
  }
}
