import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

class NotificationActiveState extends Equatable {
  final bool isEnabled;
  final NotificationActionResult? actionResult;

  const NotificationActiveState({
    this.isEnabled = false,
    this.actionResult,
  });

  NotificationActiveState copyWith({
    bool? isEnabled,
    Object? actionResult = _unset,
  }) {
    return NotificationActiveState(
      isEnabled: isEnabled ?? this.isEnabled,
      actionResult: actionResult == _unset
          ? this.actionResult
          : actionResult as NotificationActionResult?,
    );
  }

  @override
  List<Object?> get props => [
        isEnabled,
        actionResult,
      ];
}

const _unset = Object();
