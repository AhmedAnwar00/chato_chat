enum NotificationAuthorization {
  authorized,
  denied,
  deniedPermanently,
  notDetermined,
  provisional,
  unavailable,
}

class DeviceNotificationToken {
  const DeviceNotificationToken({required this.authorization, this.token});

  final NotificationAuthorization authorization;
  final String? token;

  bool get hasToken => token != null;
}
