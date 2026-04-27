import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';

/// Repository that orchestrates notification-related operations.
///
/// Combines:
/// - Local (preference)
/// - FCM (real-time events and permission)
/// - Remote (backend logs)
abstract class NotificationRepository implements Cacheable {
  /// Initialize notification system after user login or openend app.
  Future<void> init();

  /// Enable notifications (permission + token registration).
  Future<NotificationActionResult> enable();

  /// Disable notifications (token removal + local state).
  Future<NotificationActionResult> disable();

  /// Returns whether notifications are enabled (user preference).
  Future<bool> isEnabled();

  /// Unregis fcm token from BE when logout
  Future<void> dispose();

  /// Fetch notification logs from backend.
  FutureEitherList<NotificationLogEntity> getNotificationLogs();
}
