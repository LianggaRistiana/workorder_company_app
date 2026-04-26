import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_logs_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';

class NotificationLogCubit extends Cubit<NotificationLogState> {
  final GetNotificationLogsUseCase _getNotificationLogsUseCase;

  NotificationLogCubit(this._getNotificationLogsUseCase)
      : super(const NotificationLogState());

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
}
