import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_entry.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.thread,
    this.selectedMessageId,
    this.onSelectMessage,
  });

  final ChatThread thread;
  final String? selectedMessageId;
  final ValueChanged<ChatMessage>? onSelectMessage;

  @override
  Widget build(BuildContext context) {
    final messages = thread.messages;
    return ListView.separated(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: messages.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return ChatMessageEntry(
          message: message,
          selected: message.id != null && message.id == selectedMessageId,
          onSelect: onSelectMessage,
        );
      },
    );
  }
}
