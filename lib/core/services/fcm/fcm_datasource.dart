import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

/// Data source for interacting with Firebase Cloud Messaging (FCM).
///
/// This layer is responsible for:
/// - Retrieving FCM device tokens
/// - Listening to token refresh events
/// - Providing raw notification streams from Firebase
abstract class FcmDataSource {
  Future<String?> getToken();
  Stream<String> onTokenRefresh();
  Stream<RemoteMessage> onMessage();
  Stream<RemoteMessage> onMessageOpenedApp();
  Future<RemoteMessage?> getInitialMessage();
  Future<NotificationPermissionStatus> checkPermission();
  Future<NotificationPermissionStatus> requestPermission();
}

class FcmDataSourceImpl implements FcmDataSource {
  final FirebaseMessaging _messaging;

  FcmDataSourceImpl(this._messaging);

  @override
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      throw Exception("Failed to get FCM token: $e");
    }
  }

  @override
  Stream<String> onTokenRefresh() {
    return _messaging.onTokenRefresh;
  }

  @override
  Stream<RemoteMessage> onMessage() {
    return FirebaseMessaging.onMessage;
  }

  @override
  Stream<RemoteMessage> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  @override
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      return await _messaging.getInitialMessage();
    } catch (e) {
      throw Exception("Failed to get initial message: $e");
    }
  }

  @override
  Future<NotificationPermissionStatus> checkPermission() async {
    final status = await _messaging.getNotificationSettings();

    // HACK : thinks this later

    if (status.authorizationStatus == AuthorizationStatus.authorized) {
      return NotificationPermissionStatus.granted;
    } else if (status.authorizationStatus == AuthorizationStatus.denied) {
      return NotificationPermissionStatus.denied;
    } else if (status.authorizationStatus == AuthorizationStatus.provisional) {
      return NotificationPermissionStatus.denied;
    }

    return NotificationPermissionStatus.denied;
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized
        ? NotificationPermissionStatus.granted
        : NotificationPermissionStatus.denied;
  }
}
