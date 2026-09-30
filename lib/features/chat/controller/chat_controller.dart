import 'dart:async';

import 'package:my_chatoo_chat/core/auth/auth_failure.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/database/chat_database_failure.dart';
import 'package:my_chatoo_chat/core/database/chat_realtime_service.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';

enum ChatSendStatus { initial, loading, success, error }

class ChatController {
  ChatController({
    ChatRealtimeService? service,
    ChatThread? thread,
    AuthService? authService,
  }) : _service = service ?? ChatRealtimeService(),
       _authService = authService ?? AuthService(),
       thread =
           thread ??
           ChatThread(
             contactName: ChatThread.preview.contactName,
             messages: const [],
           );

  final ChatRealtimeService _service;
  final AuthService _authService;

  ChatThread thread;
  ChatSendStatus sendStatus = ChatSendStatus.initial;
  String? errorMessage;

  StreamSubscription<List<ChatMessage>>? _subscription;
  void Function()? _onChanged;
  var _signingOut = false;

  void start(void Function() onChanged) {
    _onChanged = onChanged;
    _subscription?.cancel();
    _listen();
  }

  Future<bool> signOut() async {
    if (_signingOut) {
      return false;
    }
    _signingOut = true;
    final subscription = _subscription;
    _subscription = null;
    unawaited(subscription?.cancel());
    try {
      await _authService.signOut();
      thread = ChatThread(contactName: thread.contactName, messages: const []);
      sendStatus = ChatSendStatus.initial;
      errorMessage = null;
      _notify();
      return true;
    } on AuthFailure catch (failure) {
      _listen();
      errorMessage = failure.message;
      _notify();
      return false;
    } on Object {
      _listen();
      errorMessage = 'Sign out failed. Try again.';
      _notify();
      return false;
    } finally {
      _signingOut = false;
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

  void _listen() {
    try {
      _subscription = _service.watchMessages().listen(
        _applyMessages,
        onError: _applyError,
      );
    } on Object catch (error) {
      _applyError(error);
    }
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
