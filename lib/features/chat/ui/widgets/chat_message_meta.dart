import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_themed_icon.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatMessageMeta extends StatelessWidget {
  const ChatMessageMeta({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.timeLabel,
          style: AppTextStyles.chatMessageTime.copyWith(
            color: AppColors.chatTime(brightness),
          ),
        ),
        if (message.outgoing) ...[
          const SizedBox(width: 2),
          ChatThemedIcon(
            dark: Assets.images.chatCheckDark,
            light: Assets.images.chatCheckLight,
          ),
        ],
      ],
    );
  }
}
