enum WorkOrderStatus {
  drafted,
  sent,
  approved,
  rejected,
  cancelled,
  onProgress,
  completed,
  failed;
}

extension WorkOrderStatusX on WorkOrderStatus {
  String get toJsonString {
    return switch (this) {
      WorkOrderStatus.drafted => 'drafted',
      WorkOrderStatus.sent => 'sent',
      WorkOrderStatus.approved => 'approved',
      WorkOrderStatus.rejected => 'rejected',
      WorkOrderStatus.onProgress => 'on_progress',
      WorkOrderStatus.completed => 'completed',
      WorkOrderStatus.cancelled => 'cancelled',
      WorkOrderStatus.failed => 'failed',
    };
  }

  String get displayName {
    return switch (this) {
      WorkOrderStatus.drafted => 'Draft',
      WorkOrderStatus.sent => 'Dikirim',
      WorkOrderStatus.approved => 'Disetujui',
      WorkOrderStatus.rejected => 'Ditolak',
      WorkOrderStatus.onProgress => 'Diproses',
      WorkOrderStatus.completed => 'Selesai',
      WorkOrderStatus.cancelled => 'Dibatalkan',
      WorkOrderStatus.failed => 'Gagal',
    };
  }

  static WorkOrderStatus fromString(String value) {
    return switch (value) {
      'drafted' => WorkOrderStatus.drafted,
      'sent' => WorkOrderStatus.sent,
      'approved' => WorkOrderStatus.approved,
      'rejected' => WorkOrderStatus.rejected,
      'on_progress' => WorkOrderStatus.onProgress,
      'completed' => WorkOrderStatus.completed,
      'cancelled' => WorkOrderStatus.cancelled,
      'failed' => WorkOrderStatus.failed,
      _ => throw Exception('Unknown WorkOrderStatus: $value'),
    };
  }
}
