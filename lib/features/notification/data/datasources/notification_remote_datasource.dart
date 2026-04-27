import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
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
  ApiFuture<Empty> registerToken(String token);

  /// Unregister FCM token from backend.
  ApiFuture<Empty> unregisterToken(String token);
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final ApiClient _apiClient;

  NotificationRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureList<NotificationLogModel> getNotificationLogs() async {
    final response = await _apiClient.get(Endpoints.notificationLogs);
    return ApiResponse.fromJson(
      response,
      (json) => SafeMapper.mapList(
        json,
        (data) => NotificationLogModel.fromJson(data),
      ),
    );
  }

  @override
  ApiFuture<Empty> registerToken(String token) async {
    final response = await _apiClient.post(
      Endpoints.notificationFcmToken,
      data: {"token": token},
    );
    return ApiResponse.fromJson(response, (_) => Empty());
  }

  @override
  ApiFuture<Empty> unregisterToken(String token) async {
    final response = await _apiClient.delete(
      Endpoints.notificationFcmToken,
      data: {"token": token},
    );
    return ApiResponse.fromJson(response, (_) => Empty());
  }
}
