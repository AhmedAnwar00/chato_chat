import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/core/theme/app_theme.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_bubble_shell.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_composer.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_entry.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_list.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_themed_icon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('multi-line message wraps inside the chat list', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const body =
        'This is a long multi-line message that must wrap inside the bubble without overflowing the chat layout.';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: ChatMessageList(
            thread: const ChatThread(
              contactName: 'Ada',
              messages: [
                ChatMessage(body: 'Hello', timeLabel: '11:06', outgoing: false),
                ChatMessage(body: body, timeLabel: '11:07', outgoing: true),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text(body), findsOneWidget);

    final shortLines = _lineCount(tester, 'Hello');
    final longLines = _lineCount(tester, body);
    expect(shortLines, 1);
    expect(longLines, greaterThan(1));

    final shortEntry = _entryRect(tester, 'Hello');
    final longEntry = _entryRect(tester, body);
    expect(longEntry.height, greaterThan(shortEntry.height));
    expect(longEntry.top, greaterThan(shortEntry.bottom));
    expect(longEntry.top - shortEntry.bottom, closeTo(12, 0.5));

    final longBubble = _bubbleSize(tester, body);
    final shortBubble = _bubbleSize(tester, 'Hello');
    expect(longBubble.width, lessThanOrEqualTo(287));
    expect(shortBubble.width, lessThan(longBubble.width));

    final listBottom = tester.getRect(find.byType(ChatMessageList)).bottom;
    expect(listBottom - longEntry.bottom, closeTo(8, 1));
  });

  testWidgets('composer grows up to five lines and keeps icons at the bottom', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: Column(
            children: [
              Spacer(),
              ChatComposer(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    final singleLineHeight = tester.getSize(field).height;
    await tester.enterText(
      field,
      'This is a long message that should wrap onto several lines in the composer.',
    );
    await tester.pump();

    final grownHeight = tester.getSize(field).height;
    expect(grownHeight, greaterThan(singleLineHeight));

    await tester.enterText(
      field,
      List.filled(30, 'another wrapped line of message text').join(' '),
    );
    await tester.pump();

    final cappedHeight = tester.getSize(field).height;
    expect(cappedHeight, greaterThan(singleLineHeight));
    expect(cappedHeight, lessThanOrEqualTo(singleLineHeight * 5 + 4));

    final composerBottom = tester.getRect(find.byType(ChatComposer)).bottom;
    final icons = find.byType(ChatThemedIcon);
    expect(icons, findsNWidgets(4));
    for (var index = 0; index < 4; index++) {
      expect(
        composerBottom - tester.getRect(icons.at(index)).bottom,
        lessThan(20),
      );
    }
    expect(tester.takeException(), isNull);
  });
}

int _lineCount(WidgetTester tester, String text) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
  return paragraph
      .getBoxesForSelection(
        TextSelection(baseOffset: 0, extentOffset: text.length),
      )
      .length;
}

Rect _entryRect(WidgetTester tester, String text) {
  return tester.getRect(
    find.ancestor(
      of: find.text(text),
      matching: find.byType(ChatMessageEntry),
    ),
  );
}

Size _bubbleSize(WidgetTester tester, String text) {
  final shell = find.ancestor(
    of: find.text(text),
    matching: find.byType(ChatBubbleShell),
  );
  return tester.getSize(
    find.descendant(of: shell, matching: find.byType(Container)).first,
  );
}
