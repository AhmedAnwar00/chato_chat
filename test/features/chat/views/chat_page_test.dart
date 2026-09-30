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
