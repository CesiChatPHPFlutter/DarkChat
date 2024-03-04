import 'package:flutter/material.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/pages/profil.dart';
import 'package:message_app/repositories/user_repository.dart';

class Menu extends StatefulWidget {
  final User? user;
  Menu({Key? key, required this.user}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<User> chatUsers = [];

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  void fetchChats() async {
    try {
      List<User> chats = await UserRepository.getChats(widget.user!.token!);
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
              'Discussions récentes',
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
                    // Action à effectuer lorsqu'un utilisateur est sélectionné dans la liste
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
