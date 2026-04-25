import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/services/fcm/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/presentation/handler/notification_handler.dart';

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
        appLogger.i(message.data);
        _handler.handle(message, NotificationSource.foreground);
      },
      onError: (error) {
        // TODO : add  logging
      },
    );
  }

  void _listenBackground() {
    _onOpenedSub = _dataSource.onMessageOpenedApp().listen(
      (message) {
        _handler.handle(message, NotificationSource.background);
      },
      onError: (error) {
        // TODO : optional logging
      },
    );
  }

  Future<void> _handleInitialMessage() async {
    final message = await _dataSource.getInitialMessage();

    if (message != null) {
      _handler.handle(message, NotificationSource.initial);
    }
  }

  void dispose() {
    _onMessageSub?.cancel();
    _onOpenedSub?.cancel();
  }
}
