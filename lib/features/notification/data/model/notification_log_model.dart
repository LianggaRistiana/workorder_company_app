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
      body: json.field('body').reqString(),
      createdAt: DateTime.parse(json.field('created_at').reqString()),
      resource: ResourceType.fromString(json.field('resource').reqString()),
      resourceId: json.field('resource_id').reqString(),
      isRead: json.field('is_read').reqBool(),
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
