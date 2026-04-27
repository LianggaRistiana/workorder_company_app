import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/services/fcm/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/application/handler/notification_handler.dart';

// HACK : Handle terminated message properly. currently it duplicate page push. remove widget binding and microtask to bring it previous behavior (/home)
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialMessage();
    });
  }

  void _listenForeground() {
    _onMessageSub = _dataSource.onMessage().listen(
      (message) {
        appLogger.i("Foreground Source : ${message.data}");
        _handler.handle(message, NotificationSource.foreground);
      },
      onError: (error) {
        appLogger.e(error);
      },
    );
  }

  void _listenBackground() {
    _onOpenedSub = _dataSource.onMessageOpenedApp().listen(
      (message) {
        appLogger.i("Background Source : ${message.data}");
        _handler.handle(message, NotificationSource.background);
      },
      onError: (error) {
        appLogger.e(error);
      },
    );
  }

  Future<void> _handleInitialMessage() async {
    final message = await _dataSource.getInitialMessage();
    if (message != null) {
      Future.microtask(() {
        appLogger.i("Initial Source : ${message.data}");
        _handler.handle(message, NotificationSource.initial);
      });
    }
  }

  void dispose() {
    _onMessageSub?.cancel();
    _onOpenedSub?.cancel();
  }
}
