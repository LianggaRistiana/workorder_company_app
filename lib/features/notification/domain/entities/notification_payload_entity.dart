import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

/// Represents a notification payload received from FCM.
///
/// This entity is used for handling real-time notification events,
/// such as navigation or triggering specific actions.
///
/// Note:
/// This is different from NotificationLogEntity (which comes from backend).
class NotificationPayloadEntity {
  final NotificationType type;
  final String? resource;
  final String? resourceId;

  const NotificationPayloadEntity({
    required this.type,
    this.resource,
    this.resourceId,
  });
}
