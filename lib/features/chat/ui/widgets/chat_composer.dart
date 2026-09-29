import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_themed_icon.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final fieldColor = AppColors.chatComposerField(brightness);
    final textColor = AppColors.inputText(brightness);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: ColoredBox(
          color: AppColors.chatComposerBar(brightness),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 5.5, 9, 5.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChatThemedIcon(
                    dark: Assets.images.chatPlusDark,
                    light: Assets.images.chatPlusLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: fieldColor, width: 0.33),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 6, 9, 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: TextField(
                                minLines: 1,
                                maxLines: 5,
                                style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 21 / 16,
                                  letterSpacing: -0.32,
                                ),
                                cursorColor: textColor,
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ChatThemedIcon(
                              dark: Assets.images.chatStickerDark,
                              light: Assets.images.chatStickerLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  ChatThemedIcon(
                    dark: Assets.images.chatCameraDark,
                    light: Assets.images.chatCameraLight,
                  ),
                  const SizedBox(width: 7),
                  ChatThemedIcon(
                    dark: Assets.images.chatMicDark,
                    light: Assets.images.chatMicLight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
