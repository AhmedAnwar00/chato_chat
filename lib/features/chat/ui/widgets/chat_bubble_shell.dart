import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_themed_icon.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatBubbleShell extends StatelessWidget {
  const ChatBubbleShell({
    super.key,
    required this.message,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(10, 5.5, 8, 6.5),
  });

  final ChatMessage message;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final fill = message.outgoing
        ? AppColors.chatOutgoing(brightness)
        : AppColors.chatIncoming(brightness);
    final border = AppColors.chatBubbleBorder(
      brightness,
      outgoing: message.outgoing,
    );
    final tail = Transform.flip(
      flipX: !message.outgoing,
      child: ChatThemedIcon(
        dark: message.outgoing
            ? Assets.images.chatTailOutgoingDark
            : Assets.images.chatTailIncomingDark,
        light: message.outgoing
            ? Assets.images.chatTailOutgoingLight
            : Assets.images.chatTailIncomingLight,
      ),
    );
    return Align(
      alignment: message.outgoing
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 88, maxWidth: 287),
            padding: padding,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 0.66),
            ),
            child: child,
          ),
          Positioned(
            bottom: 0,
            left: message.outgoing ? null : -7.5,
            right: message.outgoing ? -7.5 : null,
            child: tail,
          ),
        ],
      ),
    );
  }
}
