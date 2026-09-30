class ChatMessage {
  const ChatMessage({
    required this.body,
    required this.timeLabel,
    required this.outgoing,
    this.id,
    this.quoteAuthor,
    this.quoteBody,
    this.reaction,
    this.replyToMessageId,
    this.replyToSender,
    this.replyToBody,
  });

  final String? id;
  final String body;
  final String timeLabel;
  final bool outgoing;
  final String? quoteAuthor;
  final String? quoteBody;
  final String? reaction;
  final String? replyToMessageId;
  final String? replyToSender;
  final String? replyToBody;

  bool get hasQuote => quoteAuthor != null && quoteBody != null;

  bool get hasReply => replyToSender != null && replyToBody != null;

  bool get showsQuote => hasQuote || hasReply;

  String? get quotedAuthor => replyToSender ?? quoteAuthor;

  String? get quotedBody => replyToBody ?? quoteBody;

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'timeLabel': timeLabel,
      'outgoing': outgoing,
      if (quoteAuthor != null) 'quoteAuthor': quoteAuthor,
      if (quoteBody != null) 'quoteBody': quoteBody,
      if (reaction != null) 'reaction': reaction,
      if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
      if (replyToSender != null) 'replyToSender': replyToSender,
      if (replyToBody != null) 'replyToBody': replyToBody,
    };
  }

  factory ChatMessage.fromMap(
    Map<Object?, Object?> json, {
    String? id,
    required bool outgoing,
  }) {
    return ChatMessage(
      id: id,
      body: _text(json, 'body') ?? '',
      timeLabel: _text(json, 'timeLabel') ?? '',
      outgoing: outgoing,
      quoteAuthor: _text(json, 'quoteAuthor'),
      quoteBody: _text(json, 'quoteBody'),
      reaction: _text(json, 'reaction'),
      replyToMessageId: _text(json, 'replyToMessageId'),
      replyToSender: _text(json, 'replyToSender'),
      replyToBody: _text(json, 'replyToBody'),
    );
  }

  static String? _text(Map<Object?, Object?> json, String key) {
    final value = json[key];
    return value is String ? value : null;
  }
}
