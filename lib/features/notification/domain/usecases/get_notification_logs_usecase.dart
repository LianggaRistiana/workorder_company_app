import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationLogsUseCase {
  final NotificationRepository _repository;

  GetNotificationLogsUseCase(this._repository);

  FutureEitherList<NotificationLogEntity> call({
    bool forceRefresh = false,
  }) {
    return _repository.getNotificationLogs(
      forceRefresh: forceRefresh,
    );
  }
}
