import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_bubble_shell.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_meta.dart';

class ChatTextBubble extends StatelessWidget {
  const ChatTextBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.chatBubbleText(Theme.of(context).brightness);
    return ChatBubbleShell(
      message: message,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message.body,
              style: AppTextStyles.chatMessageBody.copyWith(color: color),
            ),
          ),
          const SizedBox(width: 8),
          ChatMessageMeta(message: message),
        ],
      ),
    );
  }
}
