class ChatMessage {

  final num createdAt;
  final String content;
  final String from;

  ChatMessage(this.createdAt, this.content, this.from);

  @override
  String toString() {
    return "ChatMessage { createdAt: $createdAt, content: $content, from: $from}";
  }

}