import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationStatusUseCase {
  final NotificationRepository _repository;

  GetNotificationStatusUseCase(this._repository);

  Future<bool> call() {
    return _repository.isEnabled();
  }
}
