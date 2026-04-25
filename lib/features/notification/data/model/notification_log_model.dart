import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';

class NotificationLogModel extends NotificationLogEntity {
  NotificationLogModel(
      {required super.id,
      required super.title,
      required super.body,
      required super.createdAt,
      required super.resource,
      required super.resourceId,
      super.isRead = false});

  factory NotificationLogModel.fromJson(Map<String, dynamic> json) {
    return NotificationLogModel(
      id: json.field("_id").reqString(),
      title: json.field("title").reqString(),
      body: json.field("body").reqString(),
      createdAt: json.field("createdAt").reqDate(),
      resource: json.field("data.resource").reqEnum(ResourceType.fromString),
      resourceId: json.field("data.resourceId").reqString(),
      isRead: json.field("isRead").reqBool(),
    );
  }

  NotificationLogEntity toEntity() {
    return NotificationLogEntity(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      resource: resource,
      resourceId: resourceId,
      isRead: isRead,
    );
  }
}
