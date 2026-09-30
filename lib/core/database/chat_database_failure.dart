class ChatDatabaseFailure implements Exception {
  const ChatDatabaseFailure(this.message);

  final String message;
}
