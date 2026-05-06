import 'package:shared_preferences/shared_preferences.dart';

/// Handles local subscription state.
///
/// Responsibilities:
/// - Persisting user preference for enabling/disabling notifications
abstract class NotificationLocalDataSource {
  // NOTE : currently check and request permission handled by fcm datasource
  // Future<NotificationPermissionStatus> checkPermission();
  // Future<NotificationPermissionStatus> requestPermission();
  Future<void> enableNotifications();
  Future<void> disableNotifications();
  Future<bool> isNotificationEnabled();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const _keyNotificationEnabled = 'notification_enabled';

  // @override
  // Future<NotificationPermissionStatus> checkPermission() async {
  //   final status = await Permission.notification.status;

  //   if (status.isGranted) return NotificationPermissionStatus.granted;
  //   if (status.isDenied) return NotificationPermissionStatus.denied;
  //   if (status.isPermanentlyDenied) {
  //     return NotificationPermissionStatus.permanentlyDenied;
  //   }

  //   return NotificationPermissionStatus.denied;
  // }

  // @override
  // Future<NotificationPermissionStatus> requestPermission() async {
  //   final status = await Permission.notification.request();

  //   if (status.isGranted) return NotificationPermissionStatus.granted;
  //   if (status.isDenied) return NotificationPermissionStatus.denied;
  //   if (status.isPermanentlyDenied) {
  //     return NotificationPermissionStatus.permanentlyDenied;
  //   }

  //   return NotificationPermissionStatus.denied;
  // }

  @override
  Future<void> enableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationEnabled, true);
  }

  @override
  Future<void> disableNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationEnabled, false);
  }

  @override
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationEnabled) ?? false;
  }
}
