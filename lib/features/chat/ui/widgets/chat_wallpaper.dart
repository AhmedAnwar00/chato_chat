import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatWallpaper extends StatelessWidget {
  const ChatWallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wallpaper = isDark
        ? Assets.images.chatWallpaperDark
        : Assets.images.chatWallpaperLight;
    return SizedBox.expand(child: wallpaper.image(fit: BoxFit.cover));
  }
}
