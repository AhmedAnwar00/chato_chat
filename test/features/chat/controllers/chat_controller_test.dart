import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/database/chat_realtime_service.dart';
import 'package:my_chatoo_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';

void main() {
  test('send trims and writes the message', () async {
    String? sent;
    final controller = ChatController(
      service: ChatRealtimeService(
        currentUserId: () => 'me',
        watchSnapshots: () => const Stream.empty(),
        writeMessage: (data) async {
          sent = data['body'] as String?;
        },
      ),
    );
    controller.start(() {});

    await controller.send('  hi  ');

    expect(sent, 'hi');
    expect(controller.sendStatus, ChatSendStatus.success);
    controller.dispose();
  });

  test('blank text does not write', () async {
    var writes = 0;
    final controller = ChatController(
      service: ChatRealtimeService(
        currentUserId: () => 'me',
        watchSnapshots: () => const Stream.empty(),
        writeMessage: (data) async {
          writes++;
        },
      ),
    );
    controller.start(() {});

    await controller.send('   ');

    expect(writes, 0);
    expect(controller.sendStatus, ChatSendStatus.initial);
    controller.dispose();
  });

  test('ignores a second send while one is in flight', () async {
    final gate = Completer<void>();
    var writes = 0;
    final controller = ChatController(
      service: ChatRealtimeService(
        currentUserId: () => 'me',
        watchSnapshots: () => const Stream.empty(),
        writeMessage: (data) async {
          writes++;
          await gate.future;
        },
      ),
    );
    controller.start(() {});

    final first = controller.send('one');
    await controller.send('two');
    expect(writes, 1);
    gate.complete();
    await first;
    controller.dispose();
  });

  test('listener replaces messages and keeps the contact name', () async {
    final snapshots = StreamController<Object?>();
    final controller = ChatController(
      service: ChatRealtimeService(
        currentUserId: () => 'me',
        watchSnapshots: () => snapshots.stream,
        writeMessage: (data) async {},
      ),
    );
    controller.start(() {});

    snapshots.add({
      'a': {
        'body': 'hello',
        'timeLabel': '11:06',
        'senderId': 'me',
        'createdAt': 1,
      },
    });
    await Future<void>.delayed(Duration.zero);

    expect(controller.thread.contactName, ChatThread.preview.contactName);
    expect(controller.thread.messages.single.body, 'hello');
    expect(controller.thread.messages.single.outgoing, isTrue);
    await snapshots.close();
    controller.dispose();
  });

  test('failure sets errorMessage', () async {
    final controller = ChatController(
      service: ChatRealtimeService(
        currentUserId: () => 'me',
        watchSnapshots: () => const Stream.empty(),
        writeMessage: (data) async {
          throw FirebaseException(
            plugin: 'firebase_database',
            code: 'unavailable',
          );
        },
      ),
    );
    controller.start(() {});

    await controller.send('hi');

    expect(controller.sendStatus, ChatSendStatus.error);
    expect(controller.errorMessage, 'Check your connection and try again.');
    controller.dispose();
  });
}
