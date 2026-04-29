import 'dart:async';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/services/retry_system/circuit_breaker.dart';
import 'package:workorder_company_app/core/services/retry_system/retry_helper.dart';
import 'package:workorder_company_app/core/services/retry_system/retry_policy.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/notification/data/datasources/fcm_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_local_datasource.dart';
import 'package:workorder_company_app/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource _local;
  final NotificationRemoteDatasource _remote;
  final FcmDataSource _fcm;
  final CircuitBreaker _circuitBreaker;

  StreamSubscription<String>? _tokenSubscription;

  final ListCacheHelper<NotificationLogEntity> _cache = ListCacheHelper(
    expiration: const Duration(days: 1),
  );

  NotificationRepositoryImpl(
    this._local,
    this._remote,
    this._fcm,
    this._circuitBreaker,
  );

  bool get _isListening => _tokenSubscription != null;
  bool _isStarting = false;

  @override
  Future<void> init() async {
    appLogger.i("Notification init");
    final isEnabled = await _local.isNotificationEnabled();
    if (!isEnabled) {
      appLogger.i("Notification skipped: disabled locally");
      return;
    }

    final permission = await _fcm.checkPermission();

    if (!permission.isGranted) {
      appLogger.i("Notification skipped: permission not granted");
      return;
    }
    await _startTokenSync();
  }

  @override
  Future<NotificationActionResult> enable() async {
    final permission = await _fcm.requestPermission();
    if (permission.isDenied) {
      return NotificationActionResult.permissionDenied;
    }
    if (permission.isPermanentlyDenied) {
      return NotificationActionResult.permanentlyDenied;
    }

    if (permission.isGranted) {
      await _local.enableNotifications();
      await _startTokenSync();
      return NotificationActionResult.success;
    }
    return NotificationActionResult.failed;
  }

  @override
  Future<NotificationActionResult> disable() async {
    try {
      await dispose();
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
    final permission = await _fcm.checkPermission();

    return local && permission.isGranted;
  }

  // ========================
  // Logs
  // ========================

  @override
  FutureEitherList<NotificationLogEntity> getNotificationLogs({
    bool forceRefresh = false,
  }) async {
    return _cache.fetchList(
      remoteCall: () async {
        final response = await _remote.getNotificationLogs();
        return response.data;
      },
      forceRefresh: forceRefresh,
    );
  }

  // ========================
  // Dispose to backend
  // ========================

  @override
  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
    try {
      final token = await _fcm.getToken();

      if (token != null) {
        await _remote.unregisterToken(token);
        await _fcm.deleteToken();
        appLogger.i("fcm token unregistered");
      }
    } catch (_) {
      appLogger.e("Error on unregistering fcm token");
    }
  }

  // ========================
  // Private helpers
  // ========================

  Future<void> _tokenSync(String token) async {
    await _circuitBreaker.call(() {
      return RetryHelper.retryWithJitter(
        () => _remote.registerToken(token),
        shouldRetry: RetryPolicy.shouldRetry,
      );
    });
    appLogger.i("fcm token synced");
  }

  Future<void> _startTokenSync() async {
    if (_isListening || _isStarting) return;

    _isStarting = true;

    try {
      _listenTokenRefresh();

      final token = await _fcm.getToken();
      if (token != null) {
        await _tokenSync(token);
      }
    } catch (e) {
      appLogger.e("Failed to start token sync: $e");
    } finally {
      _isStarting = false;
    }
  }

  void _listenTokenRefresh() {
    _tokenSubscription?.cancel();
    _tokenSubscription = _fcm.onTokenRefresh().listen((newToken) async {
      try {
        await _tokenSync(newToken);
        appLogger.i("fcm token refreshed");
      } catch (e) {
        appLogger.e("Failed to refreshed token: $e");
      }
    });
  }

  @override
  Future<List<NotificationLogEntity>> markAsRead(
    String? resourceId,
    ResourceType? resourceType,
  ) async {
    _cache.mapUpdate((log) {
      // Read all
      if (resourceId == null && resourceType == null) {
        return log.copyWith(isRead: true);
      }

      // Same type
      if (resourceId == null && resourceType != null) {
        if (log.resource == resourceType) {
          return log.copyWith(isRead: true);
        }
        return log;
      }

      // Same spesific
      if (resourceId != null && resourceType != null) {
        if (log.resource == resourceType && log.resourceId == resourceId) {
          return log.copyWith(isRead: true);
        }
        return log;
      }

      return log;
    });
    return _cache.value ?? [];
  }

  @override
  void clearCache() {
    _cache.clear();
  }
}
