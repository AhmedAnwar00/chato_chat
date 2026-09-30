import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';

class ChatThread {
  const ChatThread({required this.contactName, required this.messages});

  final String contactName;
  final List<ChatMessage> messages;

  static const preview = ChatThread(
    contactName: 'Ahmed Alsayed Abd...',
    messages: [
      ChatMessage(
        id: 'preview-1',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-2',
        body: 'message',
        timeLabel: '11:06',
        outgoing: true,
      ),
      ChatMessage(
        id: 'preview-3',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-4',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
        quoteAuthor: 'You',
        quoteBody: 'Quote text',
        reaction: '❤️',
      ),
      ChatMessage(
        id: 'preview-5',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
        reaction: '❤️',
      ),
      ChatMessage(
        id: 'preview-6',
        body: 'message',
        timeLabel: '11:06',
        outgoing: true,
      ),
      ChatMessage(
        id: 'preview-7',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-8',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-9',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-10',
        body: 'message',
        timeLabel: '11:06',
        outgoing: true,
      ),
      ChatMessage(
        id: 'preview-11',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
      ChatMessage(
        id: 'preview-12',
        body: 'message',
        timeLabel: '11:06',
        outgoing: true,
      ),
      ChatMessage(
        id: 'preview-13',
        body: 'message',
        timeLabel: '11:06',
        outgoing: false,
      ),
    ],
  );
}
