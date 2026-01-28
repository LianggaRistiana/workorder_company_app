enum NotificationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
}

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
