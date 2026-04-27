import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUsecase {
  final NotificationRepository repository;

  MarkNotificationAsReadUsecase(this.repository);

  Future<List<NotificationLogEntity>> call(
    String? resourceId,
    ResourceType? resourceType,
  ) async {
    return await repository.markAsRead(
      resourceId,
      resourceType,
    );
  }
}
