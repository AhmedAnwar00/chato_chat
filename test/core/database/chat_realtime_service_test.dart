import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/database/chat_database_failure.dart';
import 'package:my_chatoo_chat/core/database/chat_realtime_service.dart';

void main() {
  test('writes body, time, sender, and a server timestamp', () async {
    Map<String, dynamic>? written;
    final service = ChatRealtimeService(
      currentUserId: () => 'me',
      now: () => DateTime(2026, 9, 30, 15, 18),
      writeMessage: (data) async {
        written = data;
      },
    );

    await service.sendMessage('hello');

    expect(written, {
      'body': 'hello',
      'timeLabel': '15:18',
      'senderId': 'me',
      'createdAt': ServerValue.timestamp,
    });
  });

  test('orders messages and marks the signed-in sender as outgoing', () async {
    final service = ChatRealtimeService(
      currentUserId: () => 'me',
      watchSnapshots: () => Stream.value({
        'b': {
          'body': 'second',
          'timeLabel': '11:07',
          'senderId': 'me',
          'createdAt': 2,
        },
        'a': {
          'body': 'first',
          'timeLabel': '11:06',
          'senderId': 'them',
          'createdAt': 1,
          'quoteAuthor': 'You',
          'quoteBody': 'Quote text',
          'reaction': '❤️',
        },
        'c': {
          'body': 'same time later key',
          'timeLabel': '11:07',
          'senderId': 'them',
          'createdAt': 2,
        },
      }),
    );

    final messages = await service.watchMessages().first;

    expect(messages.map((message) => message.body), [
      'first',
      'second',
      'same time later key',
    ]);
    expect(messages[0].outgoing, isFalse);
    expect(messages[0].quoteAuthor, 'You');
    expect(messages[0].quoteBody, 'Quote text');
    expect(messages[0].reaction, '❤️');
    expect(messages[1].outgoing, isTrue);
    expect(messages[2].outgoing, isFalse);
  });

  test('returns an empty list when the snapshot is empty', () async {
    final service = ChatRealtimeService(
      currentUserId: () => 'me',
      watchSnapshots: () => Stream.value(null),
    );

    expect(await service.watchMessages().first, isEmpty);
  });

  test('maps database write errors to friendly messages', () async {
    const cases = {
      'permission-denied': 'You do not have permission to use this chat.',
      'unavailable': 'Check your connection and try again.',
      'disconnected': 'Check your connection and try again.',
      'unknown': 'Could not send your message. Try again.',
    };

    for (final entry in cases.entries) {
      final service = ChatRealtimeService(
        currentUserId: () => 'me',
        writeMessage: (data) async {
          throw FirebaseException(plugin: 'firebase_database', code: entry.key);
        },
      );

      await expectLater(
        service.sendMessage('hello'),
        throwsA(
          isA<ChatDatabaseFailure>().having(
            (failure) => failure.message,
            'message',
            entry.value,
          ),
        ),
      );
    }
  });

  test('maps listen errors to friendly messages', () async {
    final service = ChatRealtimeService(
      currentUserId: () => 'me',
      watchSnapshots: () => Stream<Object?>.error(
        FirebaseException(
          plugin: 'firebase_database',
          code: 'permission-denied',
        ),
      ),
    );

    await expectLater(
      service.watchMessages().first,
      throwsA(
        isA<ChatDatabaseFailure>().having(
          (failure) => failure.message,
          'message',
          'You do not have permission to use this chat.',
        ),
      ),
    );
  });

  test('maps unexpected errors to a friendly message', () async {
    final service = ChatRealtimeService(
      currentUserId: () => 'me',
      writeMessage: (data) async {
        throw StateError('raw database failure');
      },
    );

    await expectLater(
      service.sendMessage('hello'),
      throwsA(
        isA<ChatDatabaseFailure>().having(
          (failure) => failure.message,
          'message',
          'Could not send your message. Try again.',
        ),
      ),
    );
  });
}
