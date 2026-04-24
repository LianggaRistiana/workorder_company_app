import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';

class NotificationDispatcher {
  final NotificationNavigator _navigator;

  NotificationDispatcher(this._navigator);

  void dispatch(NotificationPayloadEntity payload) {
    switch (payload.type) {
      case NotificationType.woUpdated:
        _handleWoUpdated(payload);
        break;

      default:
        _handleUnknown(payload);
        break;
    }
  }

  void _handleWoUpdated(NotificationPayloadEntity payload) {
    _navigator.openWoUpdate(payload.resourceId ?? '');
  }

  void _handleUnknown(NotificationPayloadEntity payload) {
    _navigator.openNotificationList();
  }
}
