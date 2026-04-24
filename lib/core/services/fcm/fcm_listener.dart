import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/features/notification/presentation/handler/notification_handler.dart';

// TODO : consider to move direct on notification feature
class FcmListener {
  final FcmDataSource _dataSource;
  final NotificationHandler _handler;

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onOpenedSub;

  bool _initialized = false;

  FcmListener(this._dataSource, this._handler);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _listenForeground();
    _listenBackground();

    await _handleInitialMessage();
  }

  void _listenForeground() {
    _onMessageSub = _dataSource.onMessage().listen(
      (message) {
        _handler.handle(_map(message));
      },
      onError: (error) {
        // optional logging
      },
    );
  }

  void _listenBackground() {
    _onOpenedSub = _dataSource.onMessageOpenedApp().listen(
      (message) {
        _handler.handle(_map(message));
      },
      onError: (error) {
        // optional logging
      },
    );
  }

  Future<void> _handleInitialMessage() async {
    final message = await _dataSource.getInitialMessage();

    if (message != null) {
      _handler.handle(_map(message));
    }
  }

  NotificationPayloadEntity _map(RemoteMessage message) {
    final data = message.data;

    return NotificationPayloadEntity(
      type: _parseType(data['type']),
      resourceId: data['resource_id'] ?? '',
    );
  }

  // OPTIMIZE : i dont like it
  NotificationType _parseType(String? raw) {
    switch (raw) {
      case 'wo_updated':
        return NotificationType.woUpdated;
      default:
        return NotificationType.unknown;
    }
  }

  void dispose() {
    _onMessageSub?.cancel();
    _onOpenedSub?.cancel();
  }
}
