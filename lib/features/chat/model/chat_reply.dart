class ChatReply {
  const ChatReply({
    required this.replyToMessageId,
    required this.replyToSender,
    required this.replyToBody,
  });

  final String replyToMessageId;
  final String replyToSender;
  final String replyToBody;
}
