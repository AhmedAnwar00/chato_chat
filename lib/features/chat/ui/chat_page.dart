import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_composer.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_header.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_message_list.dart';
import 'package:my_chatoo_chat/features/chat/ui/widgets/chat_wallpaper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.controller});

  final ChatController? controller;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatController _controller = widget.controller ?? ChatController();
  String? _visibleError;

  @override
  void initState() {
    super.initState();
    _controller.start(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _send(String body) async {
    await _controller.send(body);
    return _controller.sendStatus == ChatSendStatus.success;
  }

  void _handleChange() {
    if (!mounted) return;
    setState(() {});
    final message = _controller.errorMessage;
    if (message == null) {
      _visibleError = null;
      return;
    }
    if (message == _visibleError) return;
    _visibleError = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) return;
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }

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
                ChatHeader(thread: _controller.thread),
                Expanded(child: ChatMessageList(thread: _controller.thread)),
                ChatComposer(onSend: _send),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
