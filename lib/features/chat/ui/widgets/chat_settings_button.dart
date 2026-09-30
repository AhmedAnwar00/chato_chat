import 'package:flutter/material.dart';

enum ChatSettingsAction { theme, logout }

class ChatSettingsButton extends StatelessWidget {
  const ChatSettingsButton({
    super.key,
    required this.color,
    required this.onToggleTheme,
    required this.onLogout,
  });

  final Color color;
  final void Function(Brightness brightness) onToggleTheme;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<ChatSettingsAction>(
      tooltip: 'Settings',
      child: Icon(Icons.settings, color: color, size: 32),
      onSelected: (action) {
        switch (action) {
          case ChatSettingsAction.theme:
            onToggleTheme(Theme.of(context).brightness);
          case ChatSettingsAction.logout:
            onLogout();
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ChatSettingsAction.theme,
            child: Text(isDark ? 'Light Mode' : 'Dark Mode'),
          ),
          const PopupMenuItem(
            value: ChatSettingsAction.logout,
            child: Text('Logout'),
          ),
        ];
      },
    );
  }
}
