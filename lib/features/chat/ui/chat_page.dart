import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_composer.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_header.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_list.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_wallpaper.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, this.controller = const ChatController()});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.chatComposerBar(brightness),
          ),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.background : AppColors.surfaceChat,
        body: Stack(
          children: [
            const ChatWallpaper(),
            Column(
              children: [
                ChatHeader(thread: controller.thread),
                Expanded(child: ChatMessageList(thread: controller.thread)),
                const ChatComposer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
