enum ResourceType {
  invitation,
  serviceRequest,
  workOrder,
  workReport;

  static ResourceType fromString(String value) {
    switch (value) {
      case 'invitation':
        return ResourceType.invitation;
      case 'service_request':
        return ResourceType.serviceRequest;
      case 'work_order':
        return ResourceType.workOrder;
      case 'work_report':
        return ResourceType.workReport;
      default:
        throw Exception('Unknown ResourceType: $value');
    }
  }
}

enum NotificationType {
  woAssigned,
  woUpdated,
  woCompleted,
  unknown;

  /// Convert raw string from backend/FCM to enum
  factory NotificationType.fromString(String value) {
    switch (value) {
      case 'WO_ASSIGNED':
        return NotificationType.woAssigned;
      case 'WO_UPDATED':
        return NotificationType.woUpdated;
      case 'WO_COMPLETED':
        return NotificationType.woCompleted;
      default:
        return NotificationType.unknown;
    }
  }
}

enum NotificationActionResult {
  success,
  permissionDenied,
  permanentlyDenied,
  failed,
}

enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
} 

extension NotificationPermissionStatusX on NotificationPermissionStatus {
  bool get isDenied => this == NotificationPermissionStatus.denied;
  bool get isPermanentlyDenied =>
      this == NotificationPermissionStatus.permanentlyDenied;
  bool get isGranted => this == NotificationPermissionStatus.granted;
}
