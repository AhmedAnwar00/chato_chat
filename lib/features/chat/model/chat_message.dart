class ChatMessage {
  const ChatMessage({
    required this.body,
    required this.timeLabel,
    required this.outgoing,
    this.quoteAuthor,
    this.quoteBody,
    this.reaction,
  });

  final String body;
  final String timeLabel;
  final bool outgoing;
  final String? quoteAuthor;
  final String? quoteBody;
  final String? reaction;

  bool get hasQuote => quoteAuthor != null && quoteBody != null;

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'timeLabel': timeLabel,
      'outgoing': outgoing,
      if (quoteAuthor != null) 'quoteAuthor': quoteAuthor,
      if (quoteBody != null) 'quoteBody': quoteBody,
      if (reaction != null) 'reaction': reaction,
    };
  }

  factory ChatMessage.fromMap(
    Map<Object?, Object?> json, {
    required bool outgoing,
  }) {
    return ChatMessage(
      body: _text(json, 'body') ?? '',
      timeLabel: _text(json, 'timeLabel') ?? '',
      outgoing: outgoing,
      quoteAuthor: _text(json, 'quoteAuthor'),
      quoteBody: _text(json, 'quoteBody'),
      reaction: _text(json, 'reaction'),
    );
  }

  static String? _text(Map<Object?, Object?> json, String key) {
    final value = json[key];
    return value is String ? value : null;
  }
}
