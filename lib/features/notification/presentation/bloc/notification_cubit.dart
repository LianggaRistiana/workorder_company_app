import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/disable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/domain/usecases/enable_notification_usecase.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final EnableNotificationUsecase enableUsecase;
  final DisableNotificationUsecase disableUsecase;
  final NotificationRepository repository;

  NotificationCubit({
    required this.enableUsecase,
    required this.disableUsecase,
    required this.repository,
  }) : super(NotificationState(
            osStatus: const NotificationOSStatus(
                permission: NotificationPermissionStatus.denied,
                isSubscribed: false)));

  /// Init status OS dari repository
  Future<void> initStatus() async {
    final status = await repository.getOSStatus();
    emit(state.copyWith(osStatus: status));
  }

  /// Toggle notification
  Future<void> toggleNotification(bool value) async {
    emit(state.copyWith(status: NotificationStatus.loading));

    try {
      final osStatus =
          value ? await enableUsecase.call() : await disableUsecase.call();

      emit(state.copyWith(
        osStatus: osStatus,
        status: NotificationStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
