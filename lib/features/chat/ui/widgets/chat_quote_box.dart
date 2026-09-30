import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';

class ChatQuoteBox extends StatelessWidget {
  const ChatQuoteBox({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.chatBubbleText(Theme.of(context).brightness);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.chatQuoteFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ColoredBox(
              color: AppColors.chatQuoteAccent,
              child: SizedBox(width: 4),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 9.5, 9, 10.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.quotedAuthor ?? '',
                      style: AppTextStyles.chatQuoteAuthor,
                    ),
                    Text(
                      message.quotedBody ?? '',
                      style: AppTextStyles.chatQuoteBody.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
