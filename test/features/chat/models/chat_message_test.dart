import 'package:flutter_test/flutter_test.dart';
import 'package:my_chatoo_chat/features/chat/model/chat_message.dart';

void main() {
  test('serializes optional quote and reaction fields', () {
    const message = ChatMessage(
      body: 'message',
      timeLabel: '11:06',
      outgoing: false,
      quoteAuthor: 'You',
      quoteBody: 'Quote text',
      reaction: '❤️',
    );

    expect(message.toMap(), {
      'body': 'message',
      'timeLabel': '11:06',
      'outgoing': false,
      'quoteAuthor': 'You',
      'quoteBody': 'Quote text',
      'reaction': '❤️',
    });
    expect(
      ChatMessage.fromMap(message.toMap(), outgoing: false).hasQuote,
      isTrue,
    );
  });

  test('serializes reply fields and prefers them in the quote preview', () {
    const message = ChatMessage(
      id: 'msg-1',
      body: 'reply',
      timeLabel: '11:07',
      outgoing: true,
      replyToMessageId: 'msg-0',
      replyToSender: 'Ada',
      replyToBody: 'original',
    );

    expect(message.toMap(), {
      'body': 'reply',
      'timeLabel': '11:07',
      'outgoing': true,
      'replyToMessageId': 'msg-0',
      'replyToSender': 'Ada',
      'replyToBody': 'original',
    });
    final restored = ChatMessage.fromMap(
      message.toMap(),
      id: 'msg-1',
      outgoing: true,
    );
    expect(restored.id, 'msg-1');
    expect(restored.hasReply, isTrue);
    expect(restored.showsQuote, isTrue);
    expect(restored.quotedAuthor, 'Ada');
    expect(restored.quotedBody, 'original');
  });
}
