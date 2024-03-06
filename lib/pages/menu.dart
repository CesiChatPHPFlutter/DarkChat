import 'package:flutter/material.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/pages/profil.dart';
import 'package:message_app/pages/chatRoom.dart';
import 'package:message_app/repositories/user_repository.dart';

import '../models/expireTokenException.dart';
import 'contacts.dart';
import 'login.dart';

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
    }
    on ExpireTokenException catch (error){
      Navigator.of(context)
          .pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          ModalRoute.withName('/'),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Login()),
      // );
    }
    catch (e) {
      print('Error fetching chats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Messages'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.contact_page),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Contact(user: widget.user!),
                ),
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
              'Discussions récentes',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: chatUsers.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 20, thickness: 0.5),
              itemBuilder: (context, index) {
                final user = chatUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name![0], style: TextStyle(color: Colors.black)),
                    backgroundColor: Colors.grey[300],
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
          )
        ],
      ),
    );
  }
}
