import 'package:flutter/material.dart';
import 'package:message_app/models/user.dart';

class Profil extends StatefulWidget {
  final User user;
  Profil({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark Profil'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Vos informations personnelles',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              color: Colors.grey[200], // Utilisation de la nuance de gris 200
              child: ListTile(
                title: Text(
                  'User ID',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  widget.user.user_id.toString() ?? 'N/A',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.grey[200],
              child: ListTile(
                title: Text(
                  'Name',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  widget.user.name ?? 'N/A',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.grey[200],
              child: ListTile(
                title: Text(
                  'Mail',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  widget.user.mail ?? 'N/A',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
