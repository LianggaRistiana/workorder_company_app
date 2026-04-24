import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

/// Initializes notification system on app start or after user login.
///
/// Responsibilities:
/// - Check user notification preference
/// - Validate OS permission
/// - Register FCM token if valid
/// - Start token refresh listener (handled by repository)
class InitNotificationUseCase {
  final NotificationRepository _repository;

  InitNotificationUseCase(this._repository);

  Future<void> call() async {
    await _repository.init();
  }
}
