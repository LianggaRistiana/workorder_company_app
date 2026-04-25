import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/features/notification/presentation/dispatcher/notification_dispatcher.dart';

class NotificationHandler {
  final NotificationDispatcher _dispatcher;

  NotificationHandler(this._dispatcher);

  void handle(NotificationPayloadEntity payload) {
    _dispatcher.dispatch(payload);
  }
}
