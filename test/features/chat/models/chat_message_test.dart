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
}
