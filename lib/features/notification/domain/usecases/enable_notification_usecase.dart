import 'package:logger/logger.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class EnableNotificationUsecase {
  final NotificationRepository repository;

  EnableNotificationUsecase(this.repository);

  /// Jalankan logika menyalakan notifikasi
  /// Menghandle permission OS
  Future<NotificationOSStatus> call() async {
    Logger().i("Enable notification");
    // cek permission OS dulu
    final permission = await repository.getOSStatus();

    if (permission.permission == NotificationPermissionStatus.granted) {
      Logger().i("Notification permission granted");
      // sudah granted → langsung subscribe
      await repository.enable();
    } else if (permission.permission == NotificationPermissionStatus.denied) {
      Logger().i("Notification permission denied");
      // belum granted → request
      final result = await repository.requestPermission();
      if (result == NotificationPermissionStatus.granted) {
        await repository.enable();
      }
      // kalau denied atau permanentlyDenied → jangan subscribe
    } 
    // permanentlyDenied → jangan subscribe, UI bisa handle show settings

    // kembalikan status OS terbaru
    return await repository.getOSStatus();
  }
}