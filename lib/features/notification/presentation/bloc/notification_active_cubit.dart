import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/disable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/enable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/get_notification_status_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_state.dart';

class NotificationActiveCubit extends Cubit<NotificationActiveState> {
  final EnableNotificationUseCase _enableNotificationUseCase;
  final DisableNotificationUseCase _disableNotificationUseCase;
  final GetNotificationStatusUseCase _getNotificationStatusUseCase;

  NotificationActiveCubit(
    this._enableNotificationUseCase,
    this._disableNotificationUseCase,
    this._getNotificationStatusUseCase,
  ) : super(const NotificationActiveState());

  /// Checks current notification status and updates state
  Future<void> checkStatus() async {
    final isEnabled = await _getNotificationStatusUseCase();
    emit(state.copyWith(isEnabled: isEnabled, actionResult: null));
  }

  Future<void> toggleActive() async {
    final previousState = state.isEnabled;

    emit(state.copyWith(
      isEnabled: !state.isEnabled,
      actionResult: null,
    ));

    final result = previousState
        ? await _disableNotificationUseCase()
        : await _enableNotificationUseCase();

    final isEnabled = await _getNotificationStatusUseCase();

    emit(state.copyWith(
      isEnabled: isEnabled,
      actionResult: result,
    ));
  }
}
