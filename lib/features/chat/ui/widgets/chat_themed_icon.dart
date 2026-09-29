import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatThemedIcon extends StatelessWidget {
  const ChatThemedIcon({super.key, required this.dark, required this.light});

  final SvgGenImage dark;
  final SvgGenImage light;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return (isDark ? dark : light).svg();
  }
}
