import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';

class ChatThread {
  const ChatThread({required this.contactName, required this.messages});

  final String contactName;
  final List<ChatMessage> messages;

  static const preview = ChatThread(
    contactName: 'Ahmed Alsayed Abd...',
    messages: [
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: true),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
        quoteAuthor: 'You',
        quoteBody: 'Quote text',
        reaction: '❤️',
      ),
      ChatMessage(
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
        reaction: '❤️',
      ),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: true),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: true),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: true),
      ChatMessage(body: 'message', timeLabel: '11:06', outgoing: false),
    ],
  );
}
