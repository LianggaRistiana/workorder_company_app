import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/dedup/fcm_dedup_store.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/event_bus/notification_event_bus.dart';
import 'package:workorder_company_app/features/notification/presentation/messanger/notification_messenger.dart';
import 'package:workorder_company_app/features/notification/data/model/notification_payload_model.dart';
import 'package:workorder_company_app/features/notification/data/pipeline/dispatcher/notification_dispatcher.dart';

class NotificationHandler {
  final NotificationDispatcher _dispatcher;
  final NotificationEventBus _eventBus;

  NotificationHandler(this._dispatcher, this._eventBus);

  void handle(RemoteMessage message, NotificationSource source) {
    if (FcmDedupStore.isDuplicate(message.messageId)) {
      appLogger.e("Duplicate FCM ignored: ${message.messageId}");
      return;
    }

    final payload = NotificationPayloadModel.fromRemoteMessage(message);
    _eventBus.emit(payload.resource);

    switch (source) {
      case NotificationSource.foreground:
        NotificationMessenger.showSnackbar(
            payload, () => _dispatcher.dispatch(payload));
        break;
      case NotificationSource.background:
      case NotificationSource.initial:
        _dispatcher.dispatch(payload);
        break;
    }
  }
}
