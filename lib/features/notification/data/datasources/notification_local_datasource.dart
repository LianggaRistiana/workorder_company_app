import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';

abstract class NotificationLocalDataSource {
  /// Cek permission OS sekarang
  Future<NotificationPermissionStatus> checkPermission();

  /// Request permission OS (hanya dipanggil saat user menyalakan notif)
  Future<NotificationPermissionStatus> requestPermission();

  /// Subscribe ke topic / channel OS agar notifikasi aktif
  Future<void> subscribe();

  /// Unsubscribe / disable channel
  Future<void> unsubscribe();

  /// Cek apakah subscription aktif
  Future<bool> isSubscribed();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  @override
  Future<NotificationPermissionStatus> checkPermission() async {
    Logger().i("Check notification Permission");
    // Cek status permission OS
    final status = await Permission.notification.status;

    if (status.isGranted) return NotificationPermissionStatus.granted;
    if (status.isDenied) return NotificationPermissionStatus.denied;
    if (status.isPermanentlyDenied)
      return NotificationPermissionStatus.permanentlyDenied;

    // fallback
    return NotificationPermissionStatus.denied;
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    Logger().i("Request notification Permission");
    // Request permission OS
    final status = await Permission.notification.request();

    if (status.isGranted) return NotificationPermissionStatus.granted;
    if (status.isDenied) return NotificationPermissionStatus.denied;
    if (status.isPermanentlyDenied)
      return NotificationPermissionStatus.permanentlyDenied;

    return NotificationPermissionStatus.denied;
  }

  @override
  Future<void> subscribe() async {
    // misal: subscribe ke FCM topic atau enable channel
    // contoh: FirebaseMessaging.instance.subscribeToTopic("all");
  }

  @override
  Future<void> unsubscribe() async {
    // misal: unsubscribe topic
    // FirebaseMessaging.instance.unsubscribeFromTopic("all");
  }

  @override
  Future<bool> isSubscribed() async {
    // cek status subscription
    // bisa simpan di memory/local storage
    return true;
  }
}
