import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationOSStatus osStatus;
  final NotificationStatus status;
  final String? message;

  const NotificationState({
    required this.osStatus,
    this.status = NotificationStatus.initial,
    this.message,
  });

  NotificationState copyWith({
    NotificationOSStatus? osStatus,
    NotificationStatus? status,
    String? message,
  }) {
    return NotificationState(
      osStatus: osStatus ?? this.osStatus,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [osStatus, status, message];
}
