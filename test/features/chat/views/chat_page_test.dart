import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/auth/auth_service.dart';
import 'package:my_chatoo_chat/core/database/chat_realtime_service.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/core/theme/app_theme.dart';
import 'package:my_chatoo_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';
import 'package:my_chatoo_chat/features/chat/ui/chat_page.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_reply_preview.dart';

void main() {
  testWidgets('settings menu requests the opposite theme', (tester) async {
    Brightness? toggled;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: ChatPage(
          controller: _controller(),
          onToggleTheme: (brightness) => toggled = brightness,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Light Mode'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    await tester.tap(find.text('Light Mode'));
    await tester.pumpAndSettle();

    expect(toggled, Brightness.dark);
  });

  testWidgets('logout replaces the route with login', (tester) async {
    final controller = _controller(
      authService: AuthService(signOut: () async {}),
      thread: const ChatThread(
        contactName: 'Ada',
        messages: [ChatMessage(body: 'hi', timeLabel: '11:06', outgoing: true)],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ChatPage(controller: controller),
        routes: {AppRoute.login.path: (_) => const Text('Sign In')},
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(controller.thread.messages, isEmpty);
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets(
    'reply shows a composer preview and the quote inside the bubble',
    (tester) async {
      Map<String, dynamic>? written;
      final snapshots = StreamController<Object?>();
      addTearDown(snapshots.close);
      final controller = ChatController(
        service: ChatRealtimeService(
          currentUserId: () => 'me',
          watchSnapshots: () => snapshots.stream,
          writeMessage: (data) async {
            written = data;
          },
        ),
        authService: AuthService(signOut: () async {}),
        thread: const ChatThread(contactName: 'Ada', messages: []),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: ChatPage(controller: controller),
        ),
      );
      snapshots.add({
        'abc': {
          'body': 'original',
          'timeLabel': '11:06',
          'senderId': 'them',
          'createdAt': 1,
        },
      });
      await tester.pump();

      await tester.tap(find.text('original'));
      await tester.pump();
      expect(find.text('Reply'), findsOneWidget);

      await tester.tap(find.text('Reply'));
      await tester.pump();

      expect(find.text('Ada'), findsWidgets);
      expect(find.text('original'), findsWidgets);
      expect(controller.pendingReply?.replyToSender, 'Ada');

      await tester.enterText(find.byType(TextField), 'response');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();

      expect(written?['body'], 'response');
      expect(written?['replyToMessageId'], 'abc');
      expect(written?['replyToSender'], 'Ada');
      expect(written?['replyToBody'], 'original');
      expect(find.byType(ChatReplyPreview), findsNothing);

      snapshots.add({
        'abc': {
          'body': 'original',
          'timeLabel': '11:06',
          'senderId': 'them',
          'createdAt': 1,
        },
        'def': {
          'body': 'response',
          'timeLabel': '11:07',
          'senderId': 'me',
          'createdAt': 2,
          'replyToMessageId': 'abc',
          'replyToSender': 'Ada',
          'replyToBody': 'original',
        },
      });
      await tester.pump();

      expect(find.text('response'), findsOneWidget);
      expect(find.text('Ada'), findsWidgets);
      expect(find.text('original'), findsNWidgets(2));
    },
  );
}

ChatController _controller({AuthService? authService, ChatThread? thread}) {
  return ChatController(
    service: ChatRealtimeService(
      currentUserId: () => 'me',
      watchSnapshots: () => const Stream.empty(),
      writeMessage: (data) async {},
    ),
    authService: authService,
    thread: thread,
  );
}
