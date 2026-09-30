enum NotificationAppState { foreground, background, terminated }

enum NotificationInteraction { received, opened }

class NotificationEvent {
  const NotificationEvent({
    required this.appState,
    required this.interaction,
    this.messageId,
    this.title,
    this.body,
    this.data = const <String, String>{},
  });

  final NotificationAppState appState;
  final NotificationInteraction interaction;
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, String> data;
}
