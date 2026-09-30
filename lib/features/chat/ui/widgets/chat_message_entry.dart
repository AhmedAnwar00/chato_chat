import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_quote_bubble.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_reaction_badge.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_text_bubble.dart';

class ChatMessageEntry extends StatelessWidget {
  const ChatMessageEntry({
    super.key,
    required this.message,
    this.selected = false,
    this.onSelect,
  });

  final ChatMessage message;
  final bool selected;
  final ValueChanged<ChatMessage>? onSelect;

  @override
  Widget build(BuildContext context) {
    final bubble = message.showsQuote
        ? ChatQuoteBubble(message: message)
        : ChatTextBubble(message: message);
    return GestureDetector(
      onTap: onSelect == null ? null : () => onSelect!(message),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? const Color(0x33C2F158) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: message.outgoing
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            bubble,
            if (message.reaction != null)
              Transform.translate(
                offset: const Offset(0, -4),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: message.outgoing ? 0 : (message.showsQuote ? 4 : 10),
                  ),
                  child: ChatReactionBadge(message: message),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
