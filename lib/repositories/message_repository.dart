import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:message_app/models/message.dart';
import 'package:message_app/models/config.dart';

class MessageRepository {
  
  static Future<List<Message>> messagesWithUserId(String token, int userId, int page, int perPage) async {
    // URL de l'API
    String url = '${AppConfig.apiUrl}/Message/withReceiverId/$userId/$page/$perPage';

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

    return messageList;
  }

  static Future<Message?> createMessage(String token, int receiverId, String content) async {
    // URL de l'API
    String url = '${AppConfig.apiUrl}/Message/Create';

    Map<String, dynamic> authData = {
      "jwtToken": token,
      "receiverId": receiverId,
      "content": content,
    };
    String jsonBody = json.encode(authData);

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode != 201) {
      print('Failed to send message: ${response.statusCode}');
      return null;
    }

    Map<String, dynamic> jsonResponse = json.decode(response.body);
    Message message = Message(
        message_id: jsonResponse['message_id'],
        sender_id: jsonResponse['sender_id'],
        receiver_id: jsonResponse['receiver_id'],
        content: jsonResponse['content'],
        timestamp: DateTime.tryParse(jsonResponse['timestamp'])
    );

    return message;
  }

  static Future<int> totalMessagesWithUserId(String token, int receiverId) async {
    // URL de l'API
    String url = '${AppConfig.apiUrl}/Message/totalWithReceiverId/$receiverId';

    Map<String, dynamic> authData = {
      "jwtToken": token,
    };
    String jsonBody = json.encode(authData);

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      print('Failed to fetch total of messages: ${response.statusCode}');
      return 0;
    }

    var value = int.tryParse(response.body);
    if (value == null)
      return 0;

    return value;
  }
}
