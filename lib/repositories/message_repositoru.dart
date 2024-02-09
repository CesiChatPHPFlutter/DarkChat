import 'package:message_app/models/message.dart';

class MessageRepository {
  
  static Future<List<Message>> getAllMessageById() async {
    List<Message> messageList = [];

    // URL de l'API
    String url = 'http://localhost:8888/Public/Message/GetAll';
    return messageList;
  }
}
