import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

class NotificationLogEntity {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final ResourceType resource;
  final String resourceId;
  final bool isRead;

  const NotificationLogEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.resource,
    required this.resourceId,
    this.isRead = false,
  });
}
