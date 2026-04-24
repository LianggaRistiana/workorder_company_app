enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
} // OPTIMIZE : move this enum to core

class NotificationOSStatus {
  final NotificationPermissionStatus permission;
  final bool isSubscribed;

  const NotificationOSStatus({
    required this.permission,
    required this.isSubscribed,
  });

  bool get isEnabled =>
      permission == NotificationPermissionStatus.granted && isSubscribed;
}
