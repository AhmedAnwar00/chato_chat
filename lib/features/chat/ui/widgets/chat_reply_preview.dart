import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_reply.dart';

class ChatReplyPreview extends StatelessWidget {
  const ChatReplyPreview({
    super.key,
    required this.reply,
    required this.onClear,
  });

  final ChatReply reply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = AppColors.chatBubbleText(brightness);
    return ColoredBox(
      color: AppColors.chatComposerBar(brightness),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
        child: DecoratedBox(
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
                    padding: const EdgeInsets.fromLTRB(9, 6, 4, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply.replyToSender,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.chatQuoteAuthor,
                        ),
                        Text(
                          reply.replyToBody,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.chatQuoteBody.copyWith(
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.close, size: 18, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
