import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/messenger/app_messenger.dart';
import 'package:workorder_company_app/features/notification/data/model/notification_payload_model.dart';
import 'package:workorder_company_app/features/notification/presentation/dispatcher/notification_dispatcher.dart';

class NotificationHandler {
  final NotificationDispatcher _dispatcher;

  NotificationHandler(this._dispatcher);

  void handle(RemoteMessage message, NotificationSource source) {
    final payload = NotificationPayloadModel.fromRemoteMessage(message);
    switch (source) {
      case NotificationSource.foreground:
        AppMessenger.showSnackbar(payload, () => _dispatcher.dispatch(payload));
      case NotificationSource.background:
      case NotificationSource.initial:
        _dispatcher.dispatch(payload);
        break;
    }
  }
}
