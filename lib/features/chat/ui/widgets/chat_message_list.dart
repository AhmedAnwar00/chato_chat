import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_entry.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key, required this.thread});

  final ChatThread thread;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var index = 0; index < thread.messages.length; index++) {
      if (index > 0) {
        children.add(const SizedBox(height: 12));
      }
      children.add(ChatMessageEntry(message: thread.messages[index]));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          reverse: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
