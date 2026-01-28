import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource local;

  NotificationRepositoryImpl(this.local);

  @override
  Future<void> enable() async {
    await local.subscribe();
  }

  @override
  Future<void> disable() async {
    await local.unsubscribe();
  }

  @override
  Future<NotificationOSStatus> getOSStatus() async {
    final permission = await local.checkPermission();
    final subscribed = await local.isSubscribed();
    return NotificationOSStatus(
      permission: permission,
      isSubscribed: subscribed,
    );
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() =>
      local.requestPermission();
}
