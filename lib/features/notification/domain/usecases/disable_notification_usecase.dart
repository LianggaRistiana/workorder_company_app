import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

/// Disables notification system for the user.
///
/// Flow:
/// - Remove FCM token from backend
/// - Update local preference to disabled
class DisableNotificationUseCase {
  final NotificationRepository _repository;

  DisableNotificationUseCase(this._repository);

  Future<NotificationActionResult> call() {
    return _repository.disable();
  }
}
