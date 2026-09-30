import 'dart:async';

import 'package:my_chatoo_chat/core/database/chat_database_failure.dart';
import 'package:my_chatoo_chat/core/database/chat_realtime_service.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';

enum ChatSendStatus { initial, loading, success, error }

class ChatController {
  ChatController({ChatRealtimeService? service, ChatThread? thread})
    : _service = service ?? ChatRealtimeService(),
      thread =
          thread ??
          ChatThread(
            contactName: ChatThread.preview.contactName,
            messages: const [],
          );

  final ChatRealtimeService _service;

  ChatThread thread;
  ChatSendStatus sendStatus = ChatSendStatus.initial;
  String? errorMessage;

  StreamSubscription<List<ChatMessage>>? _subscription;
  void Function()? _onChanged;

  void start(void Function() onChanged) {
    _onChanged = onChanged;
    _subscription?.cancel();
    try {
      _subscription = _service.watchMessages().listen(
        _applyMessages,
        onError: _applyError,
      );
    } on Object catch (error) {
      _applyError(error);
    }
  }

  Future<void> send(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty || sendStatus == ChatSendStatus.loading) {
      return;
    }
    sendStatus = ChatSendStatus.loading;
    errorMessage = null;
    _notify();
    try {
      await _service.sendMessage(trimmed);
      sendStatus = ChatSendStatus.success;
      errorMessage = null;
    } on ChatDatabaseFailure catch (failure) {
      sendStatus = ChatSendStatus.error;
      errorMessage = failure.message;
    } on Object {
      sendStatus = ChatSendStatus.error;
      errorMessage = 'Could not send your message. Try again.';
    }
    _notify();
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _applyMessages(List<ChatMessage> messages) {
    thread = ChatThread(contactName: thread.contactName, messages: messages);
    errorMessage = null;
    _notify();
  }

  void _applyError(Object error) {
    errorMessage = error is ChatDatabaseFailure
        ? error.message
        : 'Could not load messages. Try again.';
    _notify();
  }

  void _notify() {
    _onChanged?.call();
  }
}
