import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class DisableNotificationUsecase {
  final NotificationRepository repository;

  DisableNotificationUsecase(this.repository);

  Future<NotificationOSStatus> call() async {
    await repository.disable();
    return await repository.getOSStatus();
  }
}
