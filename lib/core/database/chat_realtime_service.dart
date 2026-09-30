import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_chatoo_chat/core/database/chat_database_failure.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_reply.dart';

typedef MessageWriter = Future<void> Function(Map<String, dynamic> data);
typedef MessageSnapshotSource = Stream<Object?> Function();

class ChatRealtimeService {
  ChatRealtimeService({
    MessageWriter? writeMessage,
    MessageSnapshotSource? watchSnapshots,
    String? Function()? currentUserId,
    DateTime Function()? now,
  }) : _writeMessage = writeMessage ?? _firebaseWrite,
       _watchSnapshots = watchSnapshots ?? _firebaseWatch,
       _currentUserId = currentUserId ?? _firebaseUserId,
       _now = now ?? DateTime.now;

  final MessageWriter _writeMessage;
  final MessageSnapshotSource _watchSnapshots;
  final String? Function() _currentUserId;
  final DateTime Function() _now;

  Future<void> sendMessage(String body, {ChatReply? reply}) async {
    try {
      await _writeMessage({
        'body': body,
        'timeLabel': _timeLabel(_now()),
        'senderId': _currentUserId(),
        'createdAt': ServerValue.timestamp,
        if (reply != null) 'replyToMessageId': reply.replyToMessageId,
        if (reply != null) 'replyToSender': reply.replyToSender,
        if (reply != null) 'replyToBody': reply.replyToBody,
      });
    } on Object catch (error) {
      throw _failure(error, sending: true);
    }
  }

  Stream<List<ChatMessage>> watchMessages() {
    try {
      return _watchSnapshots().transform(
        StreamTransformer.fromHandlers(
          handleData: (value, sink) {
            sink.add(_messagesFromValue(value, _currentUserId()));
          },
          handleError: (error, stackTrace, sink) {
            sink.addError(_failure(error, sending: false), stackTrace);
          },
        ),
      );
    } on Object catch (error) {
      throw _failure(error, sending: false);
    }
  }

  static DatabaseReference messagesRef() {
    return FirebaseDatabase.instance.ref('messages');
  }

  static Future<void> _firebaseWrite(Map<String, dynamic> data) {
    return messagesRef().push().set(data);
  }

  static Stream<Object?> _firebaseWatch() {
    if (Firebase.apps.isEmpty) {
      return const Stream.empty();
    }
    return messagesRef().onValue.map((event) => event.snapshot.value);
  }

  static String? _firebaseUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static String _timeLabel(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static List<ChatMessage> _messagesFromValue(
    Object? value,
    String? currentUserId,
  ) {
    if (value is! Map) {
      return const [];
    }
    final stored = <_StoredMessage>[];
    for (final entry in value.entries) {
      final raw = entry.value;
      if (raw is! Map) {
        continue;
      }
      final data = Map<Object?, Object?>.from(raw);
      final createdAt = data['createdAt'];
      final senderId = data['senderId'];
      stored.add(
        _StoredMessage(
          key: entry.key.toString(),
          createdAt: createdAt is num ? createdAt.toInt() : 0,
          message: ChatMessage.fromMap(
            data,
            id: entry.key.toString(),
            outgoing: senderId is String && senderId == currentUserId,
          ),
        ),
      );
    }
    stored.sort((a, b) {
      final byTime = a.createdAt.compareTo(b.createdAt);
      if (byTime != 0) {
        return byTime;
      }
      return a.key.compareTo(b.key);
    });
    return [for (final item in stored) item.message];
  }

  static ChatDatabaseFailure _failure(Object error, {required bool sending}) {
    if (error is ChatDatabaseFailure) {
      return error;
    }
    final fallback = sending
        ? 'Could not send your message. Try again.'
        : 'Could not load messages. Try again.';
    if (error is FirebaseException) {
      return ChatDatabaseFailure(_message(error.code, fallback: fallback));
    }
    return ChatDatabaseFailure(fallback);
  }

  static String _message(String code, {required String fallback}) {
    return switch (code) {
      'permission-denied' => 'You do not have permission to use this chat.',
      'unavailable' ||
      'network-error' ||
      'disconnected' => 'Check your connection and try again.',
      _ => fallback,
    };
  }
}

class _StoredMessage {
  const _StoredMessage({
    required this.key,
    required this.createdAt,
    required this.message,
  });

  final String key;
  final int createdAt;
  final ChatMessage message;
}
