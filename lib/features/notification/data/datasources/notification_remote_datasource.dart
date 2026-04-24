import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/notification/data/model/notification_log_model.dart';

/// Remote data source for notification-related API calls.
///
/// Responsibilities:
/// - Fetching notification logs from backend
/// - Registering device FCM token
/// - Unregistering device FCM token
///
/// Note:
/// This layer only communicates with backend APIs.
/// No business logic should be implemented here.
abstract class NotificationRemoteDatasource {
  /// Fetch notification logs from backend.
  ApiFutureList<NotificationLogModel> getNotificationLogs();

  /// Register FCM token to backend.
  ApiFuture<void> registerToken(String token);

  /// Unregister FCM token from backend.
  ApiFuture<void> unregisterToken(String token);
}
