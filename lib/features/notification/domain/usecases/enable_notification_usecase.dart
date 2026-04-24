import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

/// Enables notification system for the user.
///
/// Flow:
/// - Request permission (if needed)
/// - Save user preference as enabled
/// - Register FCM token to backend
class EnableNotificationUseCase {
  final NotificationRepository _repository;

  EnableNotificationUseCase(this._repository);

  Future<NotificationActionResult> call() {
    return _repository.enable();
  }
}
