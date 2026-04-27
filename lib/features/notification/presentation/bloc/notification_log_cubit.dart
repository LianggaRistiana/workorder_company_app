import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_logs_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';

class NotificationLogCubit extends Cubit<NotificationLogState> {
  final GetNotificationLogsUseCase _getNotificationLogsUseCase;
  final MarkNotificationAsReadUsecase _markNotificationAsReadUsecase;
  final Stream<RemoteMessage> _stream;
  late final StreamSubscription<RemoteMessage> _subscription;

  NotificationLogCubit(
    this._getNotificationLogsUseCase,
    this._markNotificationAsReadUsecase,
    this._stream,
  ) : super(const NotificationLogState()) {
    _subscription = _stream.listen((event) {
      fetchLogs();
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> fetchLogs({
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(status: NotificationLogStatus.loading));

    final result = await _getNotificationLogsUseCase(
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: NotificationLogStatus.error,
        errorMessage: failure.message,
      )),
      (logs) => emit(state.copyWith(
        status: NotificationLogStatus.success,
        logs: logs,
      )),
    );
  }

  Future<void> markAsRead(
    String? resourceId,
    ResourceType? resourceType,
  ) async {
    final logs = await _markNotificationAsReadUsecase(
      resourceId,
      resourceType,
    );
    emit(state.copyWith(logs: logs));
  }
}
