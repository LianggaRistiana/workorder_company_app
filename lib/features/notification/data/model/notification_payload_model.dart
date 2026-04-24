import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';

/// Model for parsing FCM RemoteMessage into a usable structure.
class NotificationPayloadModel extends NotificationPayloadEntity {
  NotificationPayloadModel({
    required super.type,
    super.resource,
    super.resourceId,
  });

  /// Create model from FCM RemoteMessage
  factory NotificationPayloadModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;

    return NotificationPayloadModel(
      type: NotificationType.fromString(data['type'] ?? ''),
      resource: data['resource'],
      resourceId: data['resource_id'],
    );
  }

  /// Convert model to domain entity
  NotificationPayloadEntity toEntity() {
    return NotificationPayloadEntity(
      type: type,
      resource: resource,
      resourceId: resourceId,
    );
  }
}
