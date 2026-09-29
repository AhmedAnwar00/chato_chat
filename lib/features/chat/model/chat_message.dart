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
}
