import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
// import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';

/// Repository that orchestrates notification-related operations.
///
/// Combines:
/// - Local (permission & preference)
/// - FCM (real-time events)
/// - Remote (backend logs)
abstract class NotificationRepository {
  /// Initialize notification system after user login.
  Future<void> init();

  /// Enable notifications (permission + token registration).
  Future<NotificationActionResult> enable();

  /// Disable notifications (token removal + local state).
  Future<NotificationActionResult> disable();

  /// Returns whether notifications are enabled (user preference).
  Future<bool> isEnabled();

  Future<void> dispose();

  // /// Stream of notifications when app is in foreground.
  // Stream<NotificationPayloadEntity> onForegroundNotification();

  // /// Stream when user opens notification.
  // Stream<NotificationPayloadEntity> onNotificationOpenedApp();

  // /// Get notification that opened the app from terminated state.
  // Future<NotificationPayloadEntity?> getInitialNotification();

  /// Fetch notification logs from backend.
  FutureEitherList<NotificationLogEntity> getNotificationLogs();
}
