import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

/// Represents a notification payload received from FCM.
///
/// This entity is used for handling real-time notification events,
/// such as navigation or triggering specific actions.
///
/// Note:
/// This is different from NotificationLogEntity (which comes from backend).
class NotificationPayloadEntity {
  final String title;
  final String body;
  final ResourceType resource;
  final String resourceId;

  const NotificationPayloadEntity({
    required this.title,
    required this.body,
    required this.resource,
    required this.resourceId,
  });
}
