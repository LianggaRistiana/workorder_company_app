import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';

abstract class NotificationRepository {
  Future<NotificationOSStatus> getOSStatus();
  Future<NotificationPermissionStatus> requestPermission();
  Future<void> enable();   // subscribe
  Future<void> disable();  // unsubscribe
}
