import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';

/// Model for parsing FCM RemoteMessage into a usable structure.
class NotificationPayloadModel extends NotificationPayloadEntity {
  NotificationPayloadModel({
    required super.title,
    required super.body,
    required super.resource,
    required super.resourceId,
  });

  factory NotificationPayloadModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;

    return NotificationPayloadModel(
      // title: data.field('title').reqString(),
      title: "New NOTIF",
      // body: data.field('body').reqString(),
      body: "New NOTIF",
      resource: data.field('resource').reqEnum(ResourceType.fromString),
      resourceId: data.field('resourceId').reqString(),
    );
  }
}
