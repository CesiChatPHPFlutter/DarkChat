import 'package:flutter/material.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/pages/profil.dart';
import 'package:message_app/pages/chatRoom.dart';
import 'package:message_app/repositories/user_repository.dart';

class Contact extends StatefulWidget {
  final User? user;
  Contact({Key? key, required this.user}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<User> chatUsers = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void fetchChats() async {
    try {
      List<User> chats = await UserRepository.getAll();
      chats = chats.where((element) => element.user_id != widget.user!.user_id).toList();
      // List<User> chats = await UserRepository.getChats(widget.user!.token!);
      setState(() {
        chatUsers = chats;
      });
    } catch (e) {
      print('Error fetching chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action à effectuer lors de l'appui sur le bouton de recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // Action à effectuer lors de l'appui sur le bouton pour lancer une discussion
              Navigator.pop(
                  context
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(user: widget.user!),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Destinataires',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name![0]),
                  ),
                  title: Text(user.name ?? ""),
                  subtitle: Text(user.mail ?? ""),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoom(user: widget.user!, otherUserId: user.user_id!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
