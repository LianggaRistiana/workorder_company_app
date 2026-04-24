import 'package:firebase_messaging/firebase_messaging.dart';

/// Data source for interacting with Firebase Cloud Messaging (FCM).
///
/// This layer is responsible for:
/// - Retrieving FCM device tokens
/// - Listening to token refresh events
/// - Providing raw notification streams from Firebase
///
/// Note:
/// This class does NOT handle:
/// - Permission (handled by LocalDataSource)
/// - Business logic (handled in domain/usecase)
/// - Navigation (handled in presentation layer)
abstract class FcmDataSource {
  /// Retrieves the current FCM token for this device.
  ///
  /// Returns:
  /// - A [String] token if available
  /// - null if token is not yet generated
  Future<String?> getToken();

  /// Emits a new token whenever Firebase refreshes it.
  ///
  /// This should be listened to and synced with backend.
  Stream<String> onTokenRefresh();

  /// Emits messages when the app is in the foreground.
  ///
  /// Use this to display in-app notifications or UI updates.
  Stream<RemoteMessage> onMessage();

  /// Emits when a user taps a notification and opens the app.
  ///
  /// Typically used to trigger navigation.
  Stream<RemoteMessage> onMessageOpenedApp();

  /// Retrieves the initial message if the app was launched
  /// from a terminated state via a notification.
  Future<RemoteMessage?> getInitialMessage();
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
}
