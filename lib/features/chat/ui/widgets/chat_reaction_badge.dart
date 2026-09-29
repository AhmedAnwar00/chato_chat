import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';

class ChatReactionBadge extends StatelessWidget {
  const ChatReactionBadge({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      height: 24.5,
      padding: const EdgeInsets.fromLTRB(9, 2, 9, 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.chatReactionFill(brightness),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.chatReactionBorder(brightness)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), offset: Offset(0, 0.66)),
        ],
      ),
      child: Text(
        message.reaction ?? '',
        style: const TextStyle(fontSize: 16, height: 1),
      ),
    );
  }
}
