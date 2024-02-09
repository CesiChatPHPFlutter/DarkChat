import 'package:flutter/material.dart';
import 'package:message_app/models/message.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/pages/profil.dart';

class Menu extends StatefulWidget {
  final User? user;
  Menu({Key? key, required this.user}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
        // Ajout un bouton qui redirige vers la page de profil 
        actions: <Widget>[
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the menu, ${widget.user?.name}!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
