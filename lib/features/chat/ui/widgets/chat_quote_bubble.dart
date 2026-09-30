import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_bubble_shell.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_meta.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_quote_box.dart';

class ChatQuoteBubble extends StatelessWidget {
  const ChatQuoteBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.chatBubbleText(Theme.of(context).brightness);
    return ChatBubbleShell(
      message: message,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 6.5),
      child: SizedBox(
        width: 196,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChatQuoteBox(message: message),
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    message.body,
                    style: AppTextStyles.chatMessageBody.copyWith(color: color),
                  ),
                ),
                const SizedBox(width: 8),
                ChatMessageMeta(message: message),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
