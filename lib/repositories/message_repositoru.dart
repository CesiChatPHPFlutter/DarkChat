import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:message_app/models/message.dart';
import 'package:message_app/models/config.dart';

class MessageRepository {
  
  static Future<List<Message>> messagesWithUserId(String token, int userId, int page, int perPage) async {
    // URL de l'API
    String url = '${AppConfig.apiUrl}/User/MessagesWithUserId/$userId/$page/$perPage';

    Map<String, dynamic> authData = {
      'jwtToken': token,
    };
    String jsonBody = json.encode(authData);

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    List<Message> messageList = [];

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      for (var item in jsonResponse) {
        Message message = Message(
            message_id: item['message_id'],
            sender_id: item['sender_id'],
            receiver_id: item['receiver_id'],
            content: item['content'],
            timestamp: DateTime.tryParse(item['timestamp'])
        );
        messageList.add(message);
      }
    } else {
      // Gérer l'erreur si la requête a échoué
      print('Failed to load chat: ${response.statusCode}');
    }

    // return Message(
    //   message_id: map['message_id'],
    //   sender_id: map['sender_id'],
    //   receiver_id: map['receiver_id'],
    //   content: map['content'],
    //   timestamp: map['timestamp'],
    // );

    return messageList;
  }
}
