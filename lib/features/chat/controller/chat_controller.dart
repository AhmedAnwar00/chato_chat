import 'package:my_chatoo_chat/features/chat/model/chat_thread.dart';

class ChatController {
  const ChatController({this.thread = ChatThread.preview});

  final ChatThread thread;
}
