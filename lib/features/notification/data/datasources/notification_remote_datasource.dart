import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/notification/data/model/notification_log_model.dart';

abstract class NotificationRemoteDatasource {
  ApiFutureList<NotificationLogModel> getLogs();
  ApiFuture<void> regisToken(String token);
  ApiFuture<void> deleteToken(String token);
}
