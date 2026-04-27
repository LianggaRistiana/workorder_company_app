import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_logs_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';

class NotificationLogCubit extends Cubit<NotificationLogState> {
  final GetNotificationLogsUseCase _getNotificationLogsUseCase;
  final Stream<RemoteMessage> _stream;
  late final StreamSubscription<RemoteMessage> _subscription;

  NotificationLogCubit(
    this._getNotificationLogsUseCase,
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

  Future<void> fetchLogs() async {
    emit(state.copyWith(status: NotificationLogStatus.loading));

    final result = await _getNotificationLogsUseCase();

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

  // TODO : ADD LOCAL MARK AS READ
  // Mark as read can put in this cubit (not even need in repo), because this cubit will alive as long as user opened the app
}
