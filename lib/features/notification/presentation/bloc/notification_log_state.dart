import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';

enum NotificationLogStatus {
  intiial,
  success,
  error,
  loading,
}

class NotificationLogState extends Equatable {
  final NotificationLogStatus status;
  final List<NotificationLogEntity> logs;
  final String? errorMessage;

  const NotificationLogState({
    this.status = NotificationLogStatus.intiial,
    this.logs = const [],
    this.errorMessage,
  });

  NotificationLogState copyWith({
    NotificationLogStatus? status,
    List<NotificationLogEntity>? logs,
    String? errorMessage,
  }) {
    return NotificationLogState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, logs, errorMessage];
}
