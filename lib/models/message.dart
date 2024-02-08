class Message{
  int? message_id;
  int? sender_id;
  int? receiver_id;
  String? content;
  DateTime? timestamp;

  Message({this.message_id, this.sender_id, this.receiver_id, this.content, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'message_id': message_id,
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'content': content,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message_id: map['message_id'],
      sender_id: map['sender_id'],
      receiver_id: map['receiver_id'],
      content: map['content'],
      timestamp: map['timestamp'],
    );
  }
}