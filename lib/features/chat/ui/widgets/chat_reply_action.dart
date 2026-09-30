import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';

class ChatReplyAction extends StatelessWidget {
  const ChatReplyAction({super.key, required this.onReply});

  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return ColoredBox(
      color: AppColors.chatComposerBar(brightness),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: onReply,
          icon: const Icon(Icons.reply, size: 18),
          label: Text('Reply', style: AppTextStyles.chatQuoteAuthor),
        ),
      ),
    );
  }
}
