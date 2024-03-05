import 'package:message_app/models/user.dart';
import 'package:message_app/models/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/expireTokenException.dart';

class UserRepository{

  static Future<List<User>> getAll() async {
    List<User> userList = [];

    // URL de l'API
    String url = '${AppConfig.apiUrl}/User/GetAll';

    // Effectuer la requête HTTP
    var response = await http.get(Uri.parse(url));

    // Vérifier si la requête a réussi (code 200)-
    if (response.statusCode == 200) {
      // Convertir la réponse JSON en une liste d'objets User
      List<dynamic> jsonResponse = json.decode(response.body);

      // Parcourir la liste JSON et créer des objets User
      for (var item in jsonResponse) {
        User user = User(
            user_id: item['userId'],
            name: item['name'],
            mail: item['mail'],
        );
        userList.add(user);
      }
    } else {
      // Gérer l'erreur si la requête a échoué
      print('Failed to load users: ${response.statusCode}');
    }
    return userList;
  }

  static Future<User?> login(String username, String password) async {
    String url = '${AppConfig.apiUrl}/User/Login';

    Map<String, dynamic> authData = {
      'mail': username,
      'password': password,
    };

    String jsonBody = json.encode(authData);

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      Map<String, dynamic>? userData = jsonResponse['user'];
      String? jwtToken = jsonResponse['jwtToken'];


      if (userData != null && jwtToken != null) {
        User user = User(
          user_id: userData['userId'],
          name: userData['name'],
          mail: userData['mail'],
          token: jwtToken,
        );
        print(jwtToken);
        print(user.token);
        print(response.body);

        return user;
      } else {
      // les données d'utilisateur ou le jeton sont manquants
      print('User data or JWT token is missing in the response.');

      return null;
    }
  } else {
    // la requête a échoué
    print('Failed to login: ${response.statusCode}');
    return null;
    }
  }

  static Future<int?> signUp(String name, String username, String password) async {
    String url = '${AppConfig.apiUrl}/User/Create';

    Map<String, dynamic> authData = {
      'name': name,
      'mail': username,
      'password': password,
    };

    String jsonBody = json.encode(authData);
    print (jsonBody);
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      // Gérer l'erreur si la requête a échoué
      print('Failed to sign up: ${response.statusCode}');
      return null;
    }

  }

  static Future<List<User>> getChats(String token) async {
    String url = '${AppConfig.apiUrl}/User/getChatsFromUserToken';

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

    List<User> userList = [];
    print(token);
    print(response);

    if (response.statusCode == 401) {
      throw ExpireTokenException("Expired Token");
    }
    else if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      for (var item in jsonResponse) {
        User user = User(
            user_id: item['userId'],
            name: item['name'],
            mail: item['mail']
        );
        userList.add(user);
      }
    } else {
      // Gérer l'erreur si la requête a échoué
      print('Failed to load chats: ${response.statusCode}');
    }
    return userList;
  }
}