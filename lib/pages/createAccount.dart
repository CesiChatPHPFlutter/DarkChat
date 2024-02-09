import 'package:flutter/material.dart';
import 'package:message_app/repositories/user_repository.dart';
import 'package:message_app/pages/login.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    String name = _nameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Vérifiez si l'un des champs est vide
    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Champs incomplets'),
            content: Text('Veuillez remplir tous les champs.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    int? responseCode = await UserRepository.signUp(name, username, password);

    if (responseCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      // Handle sign up failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Échec de la création'),
            content: Text('Échec de la création du compte. Veuillez réessayer.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Création ton Dark compte',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Create account',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
