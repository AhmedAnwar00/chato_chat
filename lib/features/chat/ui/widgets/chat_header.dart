import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/core/theme/app_text_styles.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_contact_photo.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_settings_button.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_themed_icon.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.thread,
    required this.onToggleTheme,
    required this.onLogout,
  });

  final ChatThread thread;
  final void Function(Brightness brightness) onToggleTheme;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final nameColor = brightness == Brightness.dark
        ? AppColors.surfaceLight
        : AppColors.primaryDark;
    return ColoredBox(
      color: AppColors.chatHeader(brightness),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 22, 4),
          child: Row(
            children: [
              const ChatContactPhoto(),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  thread.contactName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.chatContactName.copyWith(
                    color: nameColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ChatThemedIcon(
                dark: Assets.images.chatVideoDark,
                light: Assets.images.chatVideoLight,
              ),
              const SizedBox(width: 16),
              ChatSettingsButton(
                color: nameColor,
                onToggleTheme: onToggleTheme,
                onLogout: onLogout,
              ),
              const SizedBox(width: 16),
              ChatThemedIcon(
                dark: Assets.images.chatPhoneDark,
                light: Assets.images.chatPhoneLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
