import 'dart:async';

import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:workorder_company_app/features/notification/data/model/notification_payload_model.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _local;
  final NotificationRemoteDatasource _remote;
  final FcmDataSource _fcm;

  StreamSubscription<String>? _tokenSubscription;

  NotificationRepositoryImpl(
    this._local,
    this._remote,
    this._fcm,
  );

  @override
  Future<void> init() async {
    final isEnabled = await _local.isNotificationEnabled();
    if (!isEnabled) return;

    final permission = await _local.checkPermission();
    if (!permission.isGranted) return;

    final token = await _fcm.getToken();
    if (token != null) {
      await _remote.registerToken(token);
    }

    _listenTokenRefresh();
  }

  @override
  Future<NotificationActionResult> enable() async {
    final permission = await _fcm.requestPermission();
    // final permission = await _local.requestPermission();

    if (permission.isDenied) {
      return NotificationActionResult.permissionDenied;
    }

    if (permission.isPermanentlyDenied) {
      return NotificationActionResult.permanentlyDenied;
    }

    if (permission.isGranted) {
      await _local.enableNotifications();

      final token = await _fcm.getToken();
      if (token != null) {
        await _remote.registerToken(token);
      }

      return NotificationActionResult.success;
    }

    return NotificationActionResult.failed;
  }

  @override
  Future<NotificationActionResult> disable() async {
    try {
      final token = await _fcm.getToken();

      if (token != null) {
        await _remote.unregisterToken(token);
      }

      await _local.disableNotifications();

      return NotificationActionResult.success;
    } catch (_) {
      return NotificationActionResult.failed;
    }
  }

  // =========================
  // STATE
  // =========================

  @override
  Future<bool> isEnabled() async {
    final local = await _local.isNotificationEnabled();
    // final permission = await _local.checkPermission();
    final permission = await _fcm.checkPermission();

    return local && permission.isGranted;
  }

  // =========================
  // STREAM HANDLING
  // =========================

  @override
  Stream<NotificationPayloadEntity> onForegroundNotification() {
    return _fcm.onMessage().map(
          (message) =>
              NotificationPayloadModel.fromRemoteMessage(message).toEntity(),
        );
  }

  @override
  Stream<NotificationPayloadEntity> onNotificationOpenedApp() {
    return _fcm.onMessageOpenedApp().map(
          (message) =>
              NotificationPayloadModel.fromRemoteMessage(message).toEntity(),
        );
  }

  @override
  Future<NotificationPayloadEntity?> getInitialNotification() async {
    final message = await _fcm.getInitialMessage();

    if (message == null) return null;

    return NotificationPayloadModel.fromRemoteMessage(message).toEntity();
  }

  // ========================
  // Logs
  // ========================

  @override
  FutureEitherList<NotificationLogEntity> getNotificationLogs() async {
    return safeCall(() async {
      final payload = await _remote.getNotificationLogs();
      return payload.data;
    });
  }

  // ========================
  // Private helpers
  // ========================

  void _listenTokenRefresh() {
    _tokenSubscription?.cancel();
    _tokenSubscription = _fcm.onTokenRefresh().listen((newToken) {
      _remote.registerToken(newToken);
    });
  }
}
